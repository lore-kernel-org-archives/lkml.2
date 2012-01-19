Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2ASOth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:49:37 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:24571 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2ASOte convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 19 Jan 2012 09:49:34 -0500
Message-Id: <4F183BCA020000780006DB68@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 19 Jan 2012 14:50:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        <tglx@linutronix.de>, <luca@luca-barbieri.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ix86: atomic64 assembly improvements
References: <4F16E41B020000780006D7A5@nat28.tlf.novell.com>
 <4F16F505.8040809@zytor.com>
 <4F170679020000780006D85B@nat28.tlf.novell.com> <4F1705A8.301@zytor.com>
 <4F17EDE9020000780006D97A@nat28.tlf.novell.com>
 <4F182C55.7040305@zytor.com>
In-Reply-To: <4F182C55.7040305@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.01.12 at 15:44, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 01/19/2012 01:18 AM, Jan Beulich wrote:
>> 
>> But the code is supposed to be correct even when caches are disabled
>> (in which case LOCK# will continue to be used even on modern CPUs),
>> and this case clearly isn't covered by the current implementation. It
>> may be a good idea to adjust the patch description accordingly, but I
>> see no reason to change the patch itself.
>> 
> 
> It doesn't have anything to do with caches on or off.

How does it not? If any part of the bus topology is only 32 bits wide,
a 64-bit read or write simply can't be executed atomically without
asserting LOCK#.

Jan

