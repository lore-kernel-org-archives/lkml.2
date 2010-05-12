Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0ELU66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513Ab0ELU6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:58:55 -0400
Date: Wed, 12 May 2010 21:58:46 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [RFC PATCH] init: boot to device-mapper targets
	without an initr*
Message-ID: <20100512205846.GG2377@agk-dp.fab.redhat.com>
Mail-Followup-To: Will Drewry <wad@chromium.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <20100512203054.GA22104@z600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512203054.GA22104@z600>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 03:30:54PM -0500, Will Drewry wrote:
> The format is dm=minor,rwmode,begin,length,target,target,params,with,commas

1. If we go down this route, pick a format that gives access to the full
set of allowed table formats (or which can be extended trivially to do
so in future).  So cope with multi-line tables e.g. with a marker (empty
field?) to start a new table line.

2. It would be wise to define a name and optional uuid too, so the device is
fully visible and accessible from userspace through existing mechanisms.
Originally the name+uuid were decoupled from the mapped device itself,
but that got changed, though the code layout (dm-ioctl.c vs. dm.c) still
makes them appear to be separate.
 
> +	char target[24];
> +	char target_params[256];

I'm never a fan of hard-coded restrictions, but at least make them
explicit as #defines, so people can see at a glance what to change
if they get errors for exceeding them.

> +static void __init dm_setup_drive(void)

Arguably most of this code could be a helper function exported from drivers/md.

Alasdair

