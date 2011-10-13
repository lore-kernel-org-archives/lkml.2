Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1JMUF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:05:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab1JMUF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:05:26 -0400
Message-ID: <4E97445F.2040509@redhat.com>
Date: Thu, 13 Oct 2011 17:04:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= <niso@kth.se>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i7core_edac: fix erroneous size of static array
References: <1318530294-6829-1-git-send-email-niso@kth.se> <20111013185656.GC3064@aftab> <987664A83D2D224EAE907B061CE93D5301EE87A060@orsmsx505.amr.corp.intel.com> <20111013191448.GD3064@aftab>
In-Reply-To: <20111013191448.GD3064@aftab>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-10-2011 16:14, Borislav Petkov escreveu:
> On Thu, Oct 13, 2011 at 03:03:20PM -0400, Luck, Tony wrote:
>>> -	static int cols[8] = {
>>> +	static int cols[4] = {
>>
>> Why are these arrays "static"? Does that generate better code than
>> dynamic initialization?
> 
> They look like lookup arrays for count of things based on bit settings
> and as such they should be static because they don't ... change :). If
> they were dynamic, then inlining them in every function callsite would
> be not cool.

Btw, it probably makes sense to also declare as "const". In this specific case,
it is likely that gcc will discover that it is const anyway, and do some
optimization, but sometimes gcc don't do what I would expect ;)

Mauro.
