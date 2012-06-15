Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2FOTSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:18:47 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:35523 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753793Ab2FOTSp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:18:45 -0400
From: Philip Rakity <prakity@marvell.com>
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
CC: Philip Rakity <philipspatches@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Date: Fri, 15 Jun 2012 12:18:38 -0700
Subject: Re: [PATCH 1/2] regulator: core.c Pass voltage to notifier when
 setting voltage
Thread-Topic: [PATCH 1/2] regulator: core.c Pass voltage to notifier when
 setting voltage
Thread-Index: Ac1LK6tEXBFq1GnvQE6kaBDnlwOJPQ==
Message-ID: <DFD0DA03-D72C-4B5D-9E56-AA214202400A@marvell.com>
References: <1339784856-1779-1-git-send-email-prakity@marvell.com>
 <CADTbHxpfQpKMkwzUakUUzt1mKO5rQ2A7_vuh9SA7i6Cq0VinZg@mail.gmail.com>
In-Reply-To: <CADTbHxpfQpKMkwzUakUUzt1mKO5rQ2A7_vuh9SA7i6Cq0VinZg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15, 2012, at 11:50 AM, Pankaj Jangra wrote:

> Hi,
> 
> On Fri, Jun 15, 2012 at 11:57 PM, Philip Rakity
> <philipspatches@gmail.com> wrote:
>> V3
>> --
>> 
>> Fix type where data argument was not passed in
>> blocking_notifier_call_chain.
>> 
>> edits to check in comments (below)
>> 
>> V2
>> --
>> 
>> Incorporate performance suggestions made by Mark Brown
>> Use linux-next as base code rather than mmc-next
>> 
>> The voltage being set should be passed to the call in handler
>> requesting the callback.  Currently this is not done.
>> 
>> The callin handler cannot call regulator_get_voltage() to get the
> 
> "The calling"

I am not sure what the correct term for this.  The blocking_notifier_call_chain calls 
what ?   calling might imply blocking_notifier_call_chain() since it is doing the calling.
What is the receiver of the call named ?

> 
>> information since the mutex is held by the regulator and
>> deadlock occurs.
>> 
>> Without this change the receiver of the call in cannot know what
>> action to take.  This is used, for example, to set PAD voltages
>> when doing SD vccq voltage changes.
>> 
>> Signed-off-by: Philip Rakity <prakity@marvell.com>
>> ---
> 
> Since you are submitting your patch from the different email than your
> Singed-off email. So you should put in first line of message
> From: <your real email>.
> 
> Regards,
> Pankaj Jangra

