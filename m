Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0EDF7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 01:59:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46999 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab0EDF7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 01:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=e6SN3i70yw5zsJGFEYDjS4ceLNXnIEc0DkUYpvwhrlLYvP7JKhKqcN1ju8BzpazLy7
         GasVeRLSgCimNaHz1+2/s+yNCSKLOqpKctznfUVEMue99FMg3ZM2+WbPZcDzjqvLvDfH
         YXWMC4Pen+cWlI2LC464k89M357p0AnWa70QM=
MIME-Version: 1.0
Date: Mon, 3 May 2010 22:59:42 -0700
Message-ID: <x2gd4f60c3c1005032259p8be864bcucff91618016a0eb@mail.gmail.com>
Subject: nfs accesses of FAT fs folders causes deadlock on lock_super
From: Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: fredrickprashanth@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A FAT fs folder was shared using nfs. Accessing it over nfs causes
deadlock on lock_super since
it is acquired by both __fat_readdir and vfat_lookup in the following
call chain.

Call chain
#lock_super <----causes deadlock
#vfat_lookup
#__lookup_hash
#lookup_one_len
#compose_entry_fh
#encode_entry
#nfs3svc_encode_entry_plus
#__fat_readdir <---does lock_super
#fat_readdir
#vfs_readdir
#nfsd_readdir
#nfsd3_proc_readdirplus
#nfsd_dispatch
#svc_process
#nfsd


Is lock_super needed in the vfat_lookup?
Can it be removed?

The box was running kernel version 2.6.27.10.
But I think the FAT code has not changed much.

Thanks,
Fredrick
