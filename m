Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1HAPPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:15:09 -0400
Received: from mail.perches.com ([173.55.12.10]:4429 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab1HAPPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:15:06 -0400
Subject: Re: [PATCH] Fix a argument WARN bug of scripts/checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Hui Zhu <teawater@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <CANFwon1irVXA82qo7jM9ovNB8NFgRD-17Snta_Mg9h2xMYA29w@mail.gmail.com>
References: <4E310C44.9050002@gmail.com>
	 <CANFwon1irVXA82qo7jM9ovNB8NFgRD-17Snta_Mg9h2xMYA29w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 08:15:04 -0700
Message-ID: <1312211704.11635.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 20:09 +0800, Hui Zhu wrote:
> Ping

Please send the original patch again to Andrew Morton
<akpm@linux-foundation.org>

Acked-by: Joe Perches <joe@perches.com>

> Thanks,
> Hui
> 
> On Thu, Jul 28, 2011 at 15:14, gmail <teawater@gmail.com> wrote:
> > Sorry the prev patch have the format error.  So I re-send it.
> >
> > Get following error with a patch that have min_t error:
> > Use of uninitialized value in concatenation (.) or string at
> > scripts/checkpatch.pl line 1256.
> > WARNING:
> > This is because:
> >                                }
> >                                WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
> > It lost the first argument.
> > So make a patch to fix it.
> > Signed-off-by: Hui Zhu <teawater@gmail.com>
> > ---
> >  scripts/checkpatch.pl |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -2574,7 +2574,8 @@ sub process {
> >                                } else {
> >                                        $cast = $cast2;
> >                                }
> > -                               WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
> > +                               WARN("MINMAX",
> > +                                    "$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
> >                        }
> >                }


