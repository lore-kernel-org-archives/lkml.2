Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2EAWTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:19:08 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:50467 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755738Ab2EAWTG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120427181833.GA24587@arwen.pp.htv.fi>
References: <1335529693-14280-1-git-send-email-rnayak@ti.com>
 <CAJOA=zNzkOvzdFSuSzC015ELZWE+Jtj=H5P9fbQSHW3HZdsZow@mail.gmail.com> <20120427181833.GA24587@arwen.pp.htv.fi>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 1 May 2012 15:18:43 -0700
Message-ID: <CAJOA=zM0pwHrMM5j7c_v4Vy=r5=ChTigHDsFxTr8H_v1jNippw@mail.gmail.com>
Subject: Re: [PATCH] clk: constify parent name arrays in macros
To: balbi@ti.com
Cc: Rajendra Nayak <rnayak@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:18 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Apr 27, 2012 at 10:55:50AM -0700, Turquette, Mike wrote:
>> On Fri, Apr 27, 2012 at 5:28 AM, Rajendra Nayak <rnayak@ti.com> wrote:
>> > parent name array is now expected to be const char *, make
>> > the relevent changes in the clk macros which define
>> > default clock types.
>> >
>> > Signed-off-by: Rajendra Nayak <rnayak@ti.com>
>>
>> Good catch Rajendra.  I'll pull it into clk-next.
>>
>> Regards,
>> Mike
>>
>> > ---
>> >  include/linux/clk-private.h |    6 +++---
>> >  1 files changed, 3 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
>> > index eeae7a3..6ebec83 100644
>> > --- a/include/linux/clk-private.h
>> > +++ b/include/linux/clk-private.h
>> > @@ -70,7 +70,7 @@ struct clk {
>> >  #define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,            \
>> >                                _fixed_rate_flags)              \
>> >        static struct clk _name;                                \
>> > -       static char *_name##_parent_names[] = {};               \
>> > +       static const char *_name##_parent_names[] = {};         \
>
> does it make sense to have this as:
>
> static const char * const _name##_parent_names[] = { }; ??

Hi Felipe,

I don't think so.  We're never going to reference the member of the
array anyways, so I think the current approach is fine for just
satisfying type qualifier-sameness.

Thanks,
Mike
