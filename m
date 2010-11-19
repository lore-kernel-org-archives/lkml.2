Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0KSUif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:38:35 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10099 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab0KSUie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DPgEhhPt5MNcuSuW0fvW4VFmY+vQfOsQAd7Qmsnew1amHBV5KZl+YuoVwZ6l9OEeMZ
         /3QcL0GdGNbFH3DvFzHQ==
MIME-Version: 1.0
In-Reply-To: <87mxp53z72.fsf@gmail.com>
References: <C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu> <20101119.082944.226775934.davem@davemloft.net>
 <20101119163430.GA12353@tango.0pointer.de> <20101119.084302.71115175.davem@davemloft.net>
 <AANLkTiksmvcLKGx7-u5CnTnZU6dgOgg7wem6qf384zUg@mail.gmail.com> <87mxp53z72.fsf@gmail.com>
From: Paul Menage <menage@google.com>
Date: Fri, 19 Nov 2010 12:38:09 -0800
Message-ID: <AANLkTim3g4uOJxUzRJqQ67zf-iZ2MXVib0JW3=zLBKGg@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, mzxreary@0pointer.de,
        tytso@mit.edu, a.p.zijlstra@chello.nl, debiandev@gmail.com,
        alan@lxorguk.ukuu.org.uk, dhaval.giani@gmail.com, efault@gmx.de,
        vgoyal@redhat.com, oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 11:12 AM, Ben Gamari <bgamari.foss@gmail.com> wrote:
> On that note, is there a good reason why the notify_on_release interface
> works the way it does? Wouldn't it be simpler if the cgroup simply
> provided a file on which a process (e.g. systemd) could block?

Backwards-compatibility with cpusets, which is what cgroups evolved from.

A delete_on_release option would be possible too, for the cases where
there's really no entity that wants to do more than simply delete the
group in question.

Paul
