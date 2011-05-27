Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1E0FOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:14:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37811 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1E0FOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=qoD6djCe0XQcJ2WBopRKQDnX2Ma4N5azRIJw2rGDjVHk85tsEHZ/6ke4oCcBlMDOlO
         9UY0mup+rs7CkxW+FddGsMm16IkfodzLbs/z/ODs71k16u8pecGWubM1guW4U/uJBy2m
         eYFq9hHR3eFJp4kzH+0EzSLz1O4fzk4c33UH0=
MIME-Version: 1.0
Date: Fri, 27 May 2011 00:14:19 -0500
Message-ID: <BANLkTinVOaFwkCf33iKNk8GjqiiBEF5N3w@mail.gmail.com>
Subject: Big performance improvements seen with cifs async write patches even
 over localhost
From: Steve French <smfrench@gmail.com>
To: linux-cifs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did some informal testing of Jeff Layton's cifs async_write patch set
tonight (recent kernel). Copying 700MB sequentially was 20% faster
from cifs kernel client to Samba 3.6 with his patches - even mounted
over localhost (where network latency is a much smaller issue) and
with a slow laptop drive!

I was simply doing

time dd if=/dev/zero of=/mnt/null bs=1M count=700

repeated 4 times each way (with old module, and with same code with
Jeff's cifs async write code builtin), deleting the target file in
between each run.

I am looking forward to trying this over GigE tomorrow to servers with
faster disks.



-- 
Thanks,

Steve
