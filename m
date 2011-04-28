Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab1D1BHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 21:07:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39465 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438Ab1D1BHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 21:07:42 -0400
Message-ID: <4DB8BDC4.508@zytor.com>
Date: Wed, 27 Apr 2011 18:07:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110422 Fedora/3.1.9-7.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: avoid pointless fields of struct cpuinfo_x86
References: <4DB84D4C020000780003E675@vpn.id2.novell.com>
In-Reply-To: <4DB84D4C020000780003E675@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 08:07 AM, Jan Beulich wrote:
> Several of the flag fields of this structure are completely unused in
> certain (common) configurations. Don't pointlessly reserve space for
> them, and have truly flag-only fields consume a single bit only.
> 
> Make functionality detection conditional upon (partly new) config
> options that are now also used to control the presence of those
> fields.

If you're going to make them bitflags, please use the features array we
already have.  I do not think there is any point in compressing the
array if we're not doing something epicly wrong.

One thing I would like to see is to move the bug flags into an array
separate from the features array; the bug array should be OR'd together
(if there is a bug on any CPU, it is here) instead of AND'ed; or we
could just put them into the features array with negative logic (the
lack of a bug is a feature.)

That way we get to reuse all of our machinery.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

