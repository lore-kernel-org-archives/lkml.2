Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab2I2Avw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:51:52 -0400
Received: from nm9.bullet.mail.ne1.yahoo.com ([98.138.90.72]:34609 "HELO
	nm9.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759228Ab2I2Avu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:51:50 -0400
X-Yahoo-Newman-Id: 966969.26433.bm@omp1024.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0_4XJXAVM1k5w9fxKgO5AUkHIO5Tax_UDoyvsfhPbtTnCOw
 vAj7D4o2Z1JKYsmjoSPgcnumbvB6k8d8l6uiA5MxpHcVrwCvHGEfXYGjp.pe
 XqdOl9Pg2tEMT5w6_XzJDXr4qAHJLcElCouG.8Q7bg0XCbPopfEa0spCUmrt
 gmhkD88zYIvqfmA6.1XeWtkc2CUTcPIbgLsS0oyH9qINBR14ApZ7DVDUgjG9
 yoeskx9QAxJWIYnTe98bL1d4pyKySYEaY5EWhogJ1vQqMlNoAB942_OgEmJ_
 abMWT8BnFwYz0INgb4V.fLfb332W1T58_8AqRUv5YCMQWLCvWVxgFGT3mMV6
 FYkhogQTYYm_6.HlBa45r0liKN3nri2_BXR8AisdCS74GYAFiK6Dxf3HXIaS
 LtY1wWu7kovfgFLNtLONT3nRlT5V51AojSSSRWh0YkKfdGxJm4Q--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50664627.6050302@att.net>
Date: Fri, 28 Sep 2012 19:51:51 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/10] bug.h: Make BUILD_BUG_ON generate compile-time error
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com> <1348874411-28288-9-git-send-email-daniel.santos@pobox.com> <20120929003239.GA14293@jtriplet-mobl1>
In-Reply-To: <20120929003239.GA14293@jtriplet-mobl1>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 07:32 PM, Josh Triplett wrote:
> On Fri, Sep 28, 2012 at 06:20:09PM -0500, Daniel Santos wrote:
>> Negative sized arrays wont create a compile-time error in some cases
>> starting with gcc 4.4 (e.g., inlined functions), but gcc 4.3 introduced
>> the error function attribute that will.  This patch modifies
>> BUILD_BUG_ON to behave like BUILD_BUG already does, using the error
>> function attribute so that you don't have to build the entire kernel to
>> discover that you have a problem, and then enjoy trying to track it down
>> from a link-time error.
> Rather than doing both, and potentially producing two errors for the
> same issue, how about using __compiletime_error only, and only using the
> negative-sized array when __compiletime_error has no useful definition?
>
> For instance, in compiler.h, when defining __compiletime_error as an
> empty macro in the fallback case, you could define a
> __compiletime_error_fallback() macro that declares a negative-sized
> array; you could then define __compiletime_error_fallback() as an empty
> macro when it doesn't exist.
Oh, that's a great idea.  That will keep more of the compiler's details
in compiler*.h.

Daniel
