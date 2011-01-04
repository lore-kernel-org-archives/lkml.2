Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1ADFYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:24:32 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:52239 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1ADFYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:24:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oohJQM3gfrCyo8hqwO2QbN2fUXrDeXZwcEIstdQ8fbDGftAgmfMR3QiUBFMqnD5aeT
         GxPPM/s+NF2+D4TGzfu3rPGZTaV4qQcM8CGnyVl8E4w/YnCrd+YVhcci3t0Bahmhgixq
         wECBwRNKxolzCk1foyXu+94xZkE4yokCQXWBA=
Date: Tue, 4 Jan 2011 06:24:21 +0100
From: Tejun Heo <tj@kernel.org>
To: "Kanigeri, Hari" <h-kanigeri2@ti.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 01/32] arm/omap: use system_wq in mailbox
Message-ID: <20110104052421.GD6748@mtj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-2-git-send-email-tj@kernel.org>
 <AANLkTimMK2Ec8SQiRyRBR+MdVKhAmMaaf+oa0VK3wWsf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimMK2Ec8SQiRyRBR+MdVKhAmMaaf+oa0VK3wWsf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 03, 2011 at 03:35:45PM -0600, Kanigeri, Hari wrote:
> This was changed to dedicated work queue because of performance issues
> when there is heavy mailbox traffic between the cores.
> 
> Reference:
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg24240.html

Using dedicated workqueue or system_wq doesn't make any difference in
terms of execution latency anymore.  Sleeping work items no longer
delay execution of other work items.  If mailbox is very latency
sensitive, it might make sense to create a HIGHPRI workqueue but that
usually isn't necessary.

Thank you.

--
tejun
