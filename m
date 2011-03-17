Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab1CQJGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:06:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50933 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1CQJGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:06:42 -0400
Date: Thu, 17 Mar 2011 09:06:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: question oh macros and gcc's intelligence
Message-ID: <20110317090641.GA22723@ZenIV.linux.org.uk>
References: <201103170848.57688.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103170848.57688.oneukum@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 08:48:57AM +0100, Oliver Neukum wrote:
> Hi,
> 
> if I write:
> 
> if (le16_to_cpu(p) == CONST) a();
> 
> is gcc smart enough to convert CONST to le16 and do
> a simple comparison?

On little-endian - certainly, on big-endian - forget it.
	if (p == cpu_to_le16(CONST))
would obviously work on any architecture and yes, it would be a comparison
with compile-time constant.
