Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab1F1LhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:37:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab1F1Lgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:36:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=NLfXP0ZiU3hJH4gXvNFOVA7gzypVtVqMQLN+OtPWStaN6ADsCxg4zPTEGIsrGgwRL
	M1bi8mx4JNewB+FJjwRpQ==
MIME-Version: 1.0
In-Reply-To: <BANLkTiniBEuHKnmhoJEaVELpMefZ=Xk=bA@mail.gmail.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<4E04F0B0.4030408@codeaurora.org>
	<BANLkTi=sFtwam29i4TZdi=RO7BoytTTdrw@mail.gmail.com>
	<FFF198FBBF957F4393BA834040FEFFA202EDA3@DFLE35.ent.ti.com>
	<BANLkTiniBEuHKnmhoJEaVELpMefZ=Xk=bA@mail.gmail.com>
Date: Tue, 28 Jun 2011 04:36:46 -0700
Message-ID: <CANqkERATQbXU7ooHkUX+qieEejMAejRRvSRr606e5mF2d_qtbA@mail.gmail.com>
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
From: Brian Swetland <swetland@google.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "Grosen, Mark" <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 4:26 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Jun 28, 2011 at 12:22 AM, Grosen, Mark <mgrosen@ti.com> wrote:
>> 2. We added a special section (resource table) that is interpreted as part
>> of the loading process. The tool that generates our simple format just
>> recognizes a named section (".resource_table"), so perhaps that could be
>> done with the PIL ELF loader.
>
> I hope that DT will completely replace that "resource table" section
> eventually. We still need to try it out (as soon as DT materializes on
> ARM/pandaboard) and see how it all fits together, but in general it
> looks like DT could provide all the necessary static resource
> configuration, and then we just need to expose it to the remote
> processor.

I'm not sure I see the benefit to pulling the resource information out
of the firmware image.  The resource information is a description of
what resources the firmware requires to work properly (it needs
certain amounts of working memory, timers, peripheral interfaces like
i2c to control camera hw, etc), which will be specific to a given
firmware build.  Pulling that information out into another place adds
new ways for things to break as the firmware and its resource
requirements are now separate and could get out of sync, etc.

Brian
