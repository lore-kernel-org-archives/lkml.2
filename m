Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1EWN2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:28:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39024 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1EWN2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=ej3ZogmcEU24SvD5Z4SXZOPjoH17CKBRfCV0GqqQKenbXwKQPrCh3EL8bflq+RBlWQ
         akIl9jedMShbRELZxc/EW3nsRlbudouELx+mWrbtKma9WRGvbUy9Vjwg7Nm0Llqw+FpZ
         Ckk6iGn+BiG9msRYbQE4ceCh4NTXIrHQuv2qQ=
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: marco.stornelli@gmail.com
Subject: ramoops: is using platform_drivers correct?
Date: Mon, 23 May 2011 15:27:53 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.4-ck3; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231527.53805.stevie.trujillo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

ramoops (drivers/char/ramoops.c) is for "all" computers right? When I try to 
load it on my laptop, I get ENODEV. This is caused by platform_driver_probe() 
- the code never reaches the ramoops probe callback.

After I removed the platform_driver stuff, moving everything into ramoops_init 
and ramoops_exit it worked.
