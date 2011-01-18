Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1ARRFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:05:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40961 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1ARRFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:05:46 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=44vUGAvzfu8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=GLnSX3M_3HoieuM2VJ4A:9 a=OWZH8HyswVY-7pAYUuEA:7 a=KpvOURfjCUFHN2nVY8ilESRic54A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: brl+ccmadness@pcpool00.mathematik.uni-freiburg.de, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com, Jesper.Nilsson@axis.com,
        jeffm@suse.com
In-Reply-To: <20110117.222724.112609854.davem@davemloft.net>
References: <20110115.211722.39173519.davem@davemloft.net>
	 <20110116.220755.179947617.davem@davemloft.net>
	 <20110117143954.GA17813@pcpool00.mathematik.uni-freiburg.de>
	 <20110117.222724.112609854.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 18 Jan 2011 12:05:44 -0500
Message-ID: <1295370344.12215.18.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 22:27 -0800, David Miller wrote:

> I'm beginning to think that the align directive is there purposely to
> down-align the structure so that the amount of space that tracing
> information consumes is minimized.
> 
> I honestly can't tell, only Steven Rostedt can tell us for sure,
> because there are no commit messages or comments that explain why
> these things need to be there.

You may have missed my earlier repsonse.

The alignment was there to keep the linker from adding holes into the
sections that store this data. As the tracepoints are processed at boot
up like an array (as the initcalls are done). If the linker adds space
into the section as it puts the sections from all the object files
together, it will crash the kernel as we read that section as an array.

The min alignment I used solved this issue (which I hit on x86_64). But
I could also have made the structures aligned to a bigger alignment,
which should also work. But this will add holes between each item in the
array.

> 
> If the align directives exist for that reason, then your suggestion
> would likely completely undo what these directives are trying to
> achieve.
> 
> Someone mentioned that the default struct alignment on x86-64 is
> something rather rediculious like 32 bytes or something like that.
> Yet someone else suggested to use __aligned__(32) to fix this, so
> color me completely confused.

If you have another idea to keep the linker from breaking the section up
where it can't be read as an array, I'm all ears :-)

-- Steve


