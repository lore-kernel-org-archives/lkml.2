Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab2ENVvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:51:40 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:62275 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab2ENVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:51:39 -0400
X-Loopcount0: from 10.9.160.253
Message-ID: <4FB17DA8.1040808@dell.com>
Date: Mon, 14 May 2012 16:48:24 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
Organization: Dell Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Kamal Mostafa <kamal@canonical.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
References: <1337023652-11661-1-git-send-email-kamal@canonical.com> <20120514193718.GA6438@srcf.ucam.org> <4FB16659.6040704@dell.com> <20120514211959.GA9394@srcf.ucam.org> <4FB1774D.4080106@dell.com> <20120514212842.GA9561@srcf.ucam.org>
In-Reply-To: <20120514212842.GA9561@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/14/2012 04:28 PM, Matthew Garrett wrote:
> On Mon, May 14, 2012 at 04:21:17PM -0500, Mario Limonciello wrote:
>
>> The outliers of Inspiron and XPS don't seem to follow the interface as
>> explicitly.  It is not broken on Windows.  I don't have an
>> understanding why it's not, but conjecture that it's a different
>> interface being used on these that I don't have information on yet.
> If we're using a different interface to Windows then we're still doing
> it wrong. I'll take patches that port us to the interface that's
> actually being used, but I won't take patches that just try to cover up
> a broken interface that the vendor doesn't test.
The problems were exposed on newer XPS laptops because those platforms were not tested during platform development.  There really isn't a scalable way to represent whether a platform was or wasn't tested during development.  In a lot of situation things just work.  I would like to do the right thing for the users with what information and resources are available right now to put them in a better state.  An aggressive approach of not taking patches to cover a broken interface won't fix the problem of not testing machines already in the market, it will just put end users of the kernel module at a disadvantage.
>> You would be better to only match on Latitude and Vostro and anything
>> else that people want to opt in via a paramater than to remove the
>> interface entirely IMO.
> If Windows uses this interface on Latitude and Vostro then I'll do that,
> but otherwise no.
The problem is this isn't something that can be quantified to match all different Dell laptops.  Specifications, ODMS, IBVs, and requirements change over time on different laptops so this kernel module is really just a line of best fit.  You can be sure the matching driver and tool on the windows side will rev and collect special case scenarios as laptops come out.  If you want to continue to best represent things going forward do this:

1) Don't blacklist any Latitude or Vostro.  These are tested during platform development.
2) Leave those compal_laptop supported ones blacklisted.
3) Blacklist 2010-2012 XPS.  These are currently not tested during platform development.
4) If problems start to show up on Inspiron, blacklist them invidually.  These platforms are currently tested during platform development though, so hopefully issues don't crop up.
