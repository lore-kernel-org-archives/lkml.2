Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab0DKMfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 08:35:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab0DKMfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 08:35:18 -0400
Subject: Re: [PATCH 1/2] scsi: Add lockdep annotations to SAS sysfs
 attributes.
From: James Bottomley <James.Bottomley@suse.de>
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100410.214017.165974351.davem@davemloft.net>
References: <20100410.214017.165974351.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Apr 2010 07:35:12 -0500
Message-ID: <1270989312.2806.644.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-10 at 21:40 -0700, David Miller wrote:
> They are allocated dynamically, and thus need sysfs_attr_init()
> treatment.

This should all be taken care of by

commit ebd09ec93c90c8ec571d7e166832fb1fc705bf5e
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Sat Mar 20 12:44:12 2010 -0500

    [SCSI] attirbute_container: Initialize sysfs attributes with
sysfs_attr_init

I can't check the FC class, but I have checked the SAS one, and I don't
see any more lockdep warn ons ... unless there's one I'm not seeing
because of the options I've compiled with?

James


