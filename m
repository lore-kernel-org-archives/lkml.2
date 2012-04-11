Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab2DKG3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:29:40 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:33921 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750744Ab2DKG3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:29:39 -0400
Message-ID: <1334125762.31776.4.camel@thor.local>
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>, dri-devel@lists.freedesktop.org
Date: Wed, 11 Apr 2012 08:29:22 +0200
In-Reply-To: <20120410113448.540e4c1d@jbarnes-desktop>
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz>
	 <4F758400.3080907@suse.cz> <1333104359_155028@CP5-2952>
	 <20120409101119.47e770b2@jbarnes-desktop> <4F83F3B5.8080704@suse.cz>
	 <20120410092619.26a15165@jbarnes-desktop> <4F8477D1.4080102@suse.cz>
	 <20120410113448.540e4c1d@jbarnes-desktop>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1.0 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2012-04-10 at 11:34 -0700, Jesse Barnes wrote: 
> On Tue, 10 Apr 2012 20:11:29 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
> > On 04/10/2012 06:26 PM, Jesse Barnes wrote:
> > > So port hotplug is always reporting that port C has a hotplug
> > > interrupt though...  If you write 0x3 back to it does the interrupt
> > > stop?
> > 
> > I'm not sure I got it right. This doesn't help:
> > --- a/drivers/gpu/drm/i915/i915_irq.c
> > +++ b/drivers/gpu/drm/i915/i915_irq.c
> > @@ -1416,6 +1416,17 @@ static irqreturn_t
> > i915_driver_irq_handler(DRM_IRQ_ARGS)
> >                 iir = new_iir;
> >         }
> > 
> > +       if (ret == IRQ_NONE) {
> > +               u32 hp = I915_READ(PORT_HOTPLUG_STAT);
> > +               if (hp) {
> > +                       I915_WRITE(PORT_HOTPLUG_STAT, hp);
> > +                       I915_READ(PORT_HOTPLUG_STAT);
> > +               }
> > +
> > +               if (printk_ratelimit())
> > +                       printk(KERN_DEBUG "%s: %.8x\n", __func__, hp);
> > +
> > +       }
> > 
> >         return ret;
> >  }
> 
> Yeah that looks right, you still get 0x300?

You said 'If you write 0x3 back' above, but this code writes 0x300.
Which is right?


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
