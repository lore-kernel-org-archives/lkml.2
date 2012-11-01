Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992625Ab2KAW6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:58:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992551Ab2KAW6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:58:08 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=iHy4KzXKIIwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NE78AOKw864A:10 a=Wn7OnVGmgRzFgaPCjT0A:9 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351810685.4004.124.camel@gandalf.local.home>
Subject: Re: [PATCH RT 3/4] net: netfilter: Serialize xt_write_recseq
 sections on RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter LaDow <petela@gocougs.wsu.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>
Date: Thu, 01 Nov 2012 18:58:05 -0400
In-Reply-To: <CAN8Q1Ecq9T5HC60_ta8Xr9kKyAe8Fjrd8znV9MpDTYqkSSptOw@mail.gmail.com>
References: <20121031003258.811955127@goodmis.org>
	 <20121031003314.763160265@goodmis.org>
	 <CAN8Q1EcVfzJJh+XMeXMMk33kwyyyRoEWsuEbSQqVW0Vz3i3Vuw@mail.gmail.com>
	 <alpine.LFD.2.02.1211012213460.2756@ionos>
	 <CAN8Q1Ecq9T5HC60_ta8Xr9kKyAe8Fjrd8znV9MpDTYqkSSptOw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-01 at 15:30 -0700, Peter LaDow wrote:
> On Thu, Nov 1, 2012 at 2:26 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Cough. You are missing a boat load of crucial fixes. There is a damned
> > good reason why 3.0.stable got 12 updates and the -rt version 14.
> 
> I don't doubt there are.  But we've only experienced one problem
> between 3.0.36-rt58 and 3.0.48-rt72.  Indeed, it might be easier to
> evaluate the risk if all the changelogs were readily available.  So
> far, however, we haven't discovered any other issues that give us any
> concerns.

They are, it's just many of them. This is the point of the stable
series, is to add patches that pose little risk and fix a real bug. Also
note that a lot of the changes in mainline stable are for drivers, which
most likely wont affect you. You may want to look at all the core code
changes though.

> 
> > Your risk assessment is definitley interesting.
> 
> We have specifically tested 3.0.36-rt58 for performance in our
> application.  Moving to 3.0.48-rt72 poses risk about whether would
> still be able to meet our performance requirements.  And with regard
> to stability, the only issue we've had since our earlier moved to
> 3.0.36-rt58 was the netfilter problem.  We initially only saw the
> problem on PPP related interfaces, so we reverted to 3.0.3 (non-rt)
> for PPP related issues.
> 
> Now, if you think there are some issues that should raise eyebrows, or
> can point me to a list of changelogs, I'd be happy to evaluate them.

Note, if you are only interested in -rt related fixes, all -rt only
fixes are pushed as a separate update. Look for releases where only the
-rt version changes. I update the -rt version when doing a new merge of
the mainline stable release and I update the -rt version if there's -rt
only changes added. I never combine the two, so you don't need to look
at the changes where the mainline version number changes (ie. 3.0.x).

v3.0.34-rt55
v3.0.35-rt56
v3.0.36-rt57
v3.0.36-rt58
v3.0.39-rt59

-rt56 was only the merge of 3.0.35. -rt 57 was only the merge of 3.0.36.
-rt58 had only -rt specific changes applied. -rt59 was only the merge of
3.0.39.

Simply need to do a: git log v3.0.36-rt58 to see the -rt specific
changes since -rt57 (the merge of 3.0.36).

Note, if we find a bug in mainline, we do not add it to the -rt series.
Instead we forward a note to the mainline stable maintainer (Either Greg
or Ben) and Cc the stable mailing list. The stable releases only get
those fixes via mainline. Thus, you will be missing fixes that we find
in mainline and push it back to them.

-- Steve


