Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab2I1Jiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:38:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58519 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab2I1Jiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:38:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 28 Sep 2012 11:38:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: remove global lock around address handlers,
 convert to RCU
Message-ID: <20120928113837.4f5de6ef@stein>
In-Reply-To: <20120927214436.1da8b8ef@stein>
References: <1345359002.6089.3.camel@thor>
	<20120819122759.30f9981f@stein>
	<1345403610.7706.72.camel@thor>
	<20120820030450.7f5bfa37@stein>
	<20120927214436.1da8b8ef@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 27 Stefan Richter wrote:
> --- a/drivers/firewire/core-transaction.c
> +++ b/drivers/firewire/core-transaction.c
> @@ -489,7 +489,7 @@ static struct fw_address_handler *lookup
>  {
>  	struct fw_address_handler *handler;
>  
> -	list_for_each_entry(handler, list, link) {
> +	list_for_each_entry_rcu(handler, list, link) {
>  		if (handler->offset < offset + length &&
>  		    offset < handler->offset + handler->length)
>  			return handler;
[...]

I will add an #include <linux/rculist.h> to core-transaction.c.
-- 
Stefan Richter
-=====-===-- =--= ===--
http://arcgraph.de/sr/
