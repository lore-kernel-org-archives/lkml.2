Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1EYJa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:30:58 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:34125 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab1EYJa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:30:57 -0400
X-ASG-Debug-ID: 1306315856-01de28096b65fa0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDCCC4C.5030606@fusionio.com>
Date: Wed, 25 May 2011 11:30:52 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
References: <20110519222404.GG12600@redhat.com>			 <20110521210013.GJ2271@linux.vnet.ibm.com>			 <20110523152141.GB4019@redhat.com>			 <20110523153848.GC2310@linux.vnet.ibm.com>		 <1306189249.15900.10.camel@t41.thuisdomein> <4DDB7D36.60905@fusionio.com>	 <1306312155.9059.8.camel@t41.thuisdomein> <4DDCC1E4.706@fusionio.com> <1306314848.9059.17.camel@t41.thuisdomein>
X-ASG-Orig-Subj: Re: Mysterious CFQ crash and RCU
In-Reply-To: <1306314848.9059.17.camel@t41.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306315856
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-25 11:13, Paul Bolle wrote:
> On Wed, 2011-05-25 at 10:46 +0200, Jens Axboe wrote:
>> Are you easily able to test a patch out?
> 
> Yes. 

Super!

>> Having a
>> test case on your machine that is as easily reproducible as it seems to
>> be, would be a great place to test ideas out.
> 
> Maybe I should now also try to build CFQ (and the other schedulers, I
> guess) as a module (instead of Fedora's default of builtin). That might
> make it both easier and quicker to iterate over a number of ideas.

As most debug patches will likely end up in cfq, yes that makes sense.

> Does using the schedulers as modules require any handholding (on your
> part, I'm afraid) or is it not really different from using any other
> kernel module?

If you build CFQ modular, then all you have to do is switch to using CFQ
before starting your testing:

# echo cfq > /sys/block/sda/queue/scheduler

and switch sda to eg noop before you can remove cfq-iosched again. As
long as things crash, then you wont be able to remove cfq anyway and you
have to reboot to test something new anyway. So the modular nature of
cfq-iosched may not help you all that much in the end.


-- 
Jens Axboe

