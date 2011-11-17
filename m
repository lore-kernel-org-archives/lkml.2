Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1KQIpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:45:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42057 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab1KQIpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:45:42 -0500
Subject: Re: [PATCH 2/7] event: don't divide events if it has field period
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Wagin <avagin@gmail.com>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Arun Sharma <asharma@fb.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, devel@openvz.org
Date: Thu, 17 Nov 2011 09:45:08 +0100
In-Reply-To: <CANaxB-xOQr=gHGRwPUoZN7cMdss48Q5A2XJvU7Kg+MaCZeqX9w@mail.gmail.com>
References: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
	 <1320670457-2633428-3-git-send-email-avagin@openvz.org>
	 <1320839740.13360.11.camel@twins> <4EBCF0EB.8080304@gmail.com>
	 <CANaxB-xOQr=gHGRwPUoZN7cMdss48Q5A2XJvU7Kg+MaCZeqX9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321519508.27735.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 11:22 +0300, Andrew Wagin wrote:
> Hello Peter,
> 
> 11 ноября 2011 г. 13:54 пользователь Andrew Vagin <avagin@gmail.com> написал:
> > On 11/09/2011 03:55 PM, Peter Zijlstra wrote:
> >>
> >> On Mon, 2011-11-07 at 15:54 +0300, Andrew Vagin wrote:
> >>>
> >>> This patch solves the following problem:
> >>>
> >>> Now some samples may be lost due to throttling. The number of samples is
> >>> restricted by sysctl_perf_event_sample_rate/HZ.  A trace event is
> >>> divided on some samples according to event's period.  I don't sure, that
> >>> we should generate more than one sample on each trace event. I think the
> >>> better way to use SAMPLE_PERIOD.
> >>
> >> It would be yes, but this code predates that, also it needs to work even
> >> if the user doesn't provide SAMPLE_PERIOD.
> 
> I have not understood exactly what I should do now.
> I'm going to send the third version of this patches. New version
> contains only a small fix according with the comment for path 4/7.
> In new version I am not going to fix the problem about which we
> discussed early. I have some reasons for it:

I already merged your previous version, it can be found in tip.

