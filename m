Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2CHPWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:22:30 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:35779 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2CHPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:22:28 -0500
Message-ID: <4F58CE25.5070906@tu-ilmenau.de>
Date: Thu, 08 Mar 2012 16:20:05 +0100
From: =?UTF-8?B?U3RlcGhhbiBCw6Ryd29sZg==?= 
	<stephan.baerwolf@tu-ilmenau.de>
Reply-To: stephan.baerwolf@tu-ilmenau.de
Organization: TU-Ilmenau
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120303 Thunderbird/10.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linaro-kernel@lists.linaro.org, panto@antoniou-consulting.com
Subject: Re: [RFC] Scheduler recorder and playback
References: <85A3EFC3-FAE0-4B3A-AAA0-85FA435A9F7B@antoniou-consulting.com>
In-Reply-To: <85A3EFC3-FAE0-4B3A-AAA0-85FA435A9F7B@antoniou-consulting.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pantelis,

what is your primary goal?

Saving power? Improving interactivity? Be more cache-optimal?

I think recording the scheduling (without drastically slowing it down) is hard to do,
since it ticks at least HZ times per second.

Replay such an recording (on a differeny platform) seems even harder to me.
Since different cpus (and number of them), different speed and a very likely not
reproduceable process-setup may noise completely the replay.

Do you also want to record/replay the behaviour of the more important loadbalancer, too?

Did you thought to compare different platforms by simply having syntetically generated
loads? (I.e. see interbench -> http://users.on.net/~ckolivas/interbench/)


If you are interested in examing the scheduling-behaviour as a function of the tuneables
(and even the HZ) - and if you are interested in getting better latency, maybe you
are interested in nitro-patch for the scheduler?
(I currently don't have an external patch-file, but you can get it integrated from
https://github.com/baerwolf/linux-stephan/commits/v3.2.9-stephan-201203030000 )

Nitro enables you to do so some things, like:

        * tune the scheduler at configuration point
        * increase the ticker-frequency way above 1000Hz
        * tune the ticker-freq. from userspace during runtime
	* change the scheduling-algo for idle-tasks


regards Stephan
