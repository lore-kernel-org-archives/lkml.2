Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1F1Tki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:40:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33661 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1F1Tk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:40:27 -0400
Message-ID: <4E0A2E26.5000001@gmail.com>
Date: Tue, 28 Jun 2011 12:40:22 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
References: <20110626193918.GA3339@joi.lan> <alpine.DEB.2.00.1106281431370.27518@router.home>
In-Reply-To: <alpine.DEB.2.00.1106281431370.27518@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 12:32 PM, Christoph Lameter wrote:
> On Sun, 26 Jun 2011, Marcin Slusarz wrote:
>
>> slub checks for poison one byte by one, which is highly inefficient
>> and shows up frequently as a highest cpu-eater in perf top.
>
> Ummm.. Performance improvements for debugging modes? If you need
> performance then switch off debuggin.

There is no reason to make things gratuitously slow.  I don't know about 
the merits of this particular patch, but I must disagree with the 
general sentiment.

We have high performance tracing, why not improve this as well.

Just last week I was trying to find the cause of memory corruption that 
only occurred at very high network packet rates.  Memory allocation 
speed was definitely getting in the way of debugging.  For me, faster 
SLUB debugging would be welcome.

David Daney
