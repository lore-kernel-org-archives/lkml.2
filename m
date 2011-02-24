Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab1BXQIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:08:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab1BXQIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:08:31 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=7fdJUjABhSQA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=rdjaIOsaiFIAylYRdOQA:9 a=CdIBOW0xoAbD6caGQ_jh0P-OcbsA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 24 Feb 2011 11:08:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: remove null checks before kfree
Message-ID: <20110224160828.GA888@home.goodmis.org>
References: <1298364821-18915-1-git-send-email-imirkin@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298364821-18915-1-git-send-email-imirkin@alum.mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 03:53:40AM -0500, Ilia Mirkin wrote:
> This patch was created with the following semantic patch:
> 
> // <smpl>
> @@
> expression E;
> @@
> 
> - if (E != NULL) kfree(E);
> + kfree(E);
> // </smpl>

OK, so when will we be removing the unlikely() from the implementations
of kfree()?

	if (unlikely(ZERO_OR_NULL_PTR(block)))
			return;

-- Steve

