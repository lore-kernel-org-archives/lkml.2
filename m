Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab1FPPO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:14:59 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:19855 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755448Ab1FPPO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:14:57 -0400
Message-ID: <4DFA1D07.1050705@draigBrady.com>
Date: Thu, 16 Jun 2011 16:11:03 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: scheduler / perf stat question about CPU-migrations
References: <E1QXDpy-0007Wr-5V@tytso-glaptop> <20110616150347.GB23624@somewhere.redhat.com>
In-Reply-To: <20110616150347.GB23624@somewhere.redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/11 16:03, Frederic Weisbecker wrote:
> On Thu, Jun 16, 2011 at 10:46:26AM -0400, Theodore Ts'o wrote:
>> Can someone tell me how I'm being confused?
>>
>> I ran the following command as root:
>>
>> 	perf stat schedtool -a 1 -e e2fsck -ft /dev/funarg/kbuild
> 
> A theory is that schedtool does:
> 
> if (!fork()) {
> 	set affinity there
> 	launch e2fsck
> }

Well `taskset` and `chrt` from util-linux don't fork at least,
so you could try those instead.

I also suggest protecting the command with --
in case perf is not stopping at the first unrecognized option.

cheers,
Pádraig.
