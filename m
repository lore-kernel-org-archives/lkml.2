Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2HRNdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 09:33:05 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45974 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab2HRNdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 09:33:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v1 2/3] PM / Sleep: introduce dpm_for_each_dev
Date: Sat, 18 Aug 2012 15:38:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <1345212420-1707-1-git-send-email-ming.lei@canonical.com> <201208180002.26563.rjw@sisk.pl> <CACVXFVNVvponQD85o4RHxF9e+JRtq-AX5kZOuxvETDSGktit5A@mail.gmail.com>
In-Reply-To: <CACVXFVNVvponQD85o4RHxF9e+JRtq-AX5kZOuxvETDSGktit5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208181538.59940.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 18, 2012, Ming Lei wrote:
> On Sat, Aug 18, 2012 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, August 17, 2012, Ming Lei wrote:
> >> +void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *))
> >
> > Is this function actually used more than once?
> 
> At least now, it is called each time before system sleep.

My question was about the number of current users of it.  Sorry for not
being clear.

If there are no more anticipated users than the current only one, please
drop the unused (void *) argument.  We can always extend it in the future
if need be and for now passing that NULL every time is just pointless.

And please fold [2/3] into [3/3] in this series.

I'm not particuarly fond of this patch, but I guess it would require some
consderable juggling of #ifdefs to fix the build breakage in a different way.

Thanks,
Rafael
