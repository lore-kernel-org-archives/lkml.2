Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966723Ab0GSUct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:32:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966703Ab0GSUcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:32:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:x-system-of-record;
	b=otUqDCjJl7kZiIwXEjcOBJ2D4NH8h54IuhXCZxUrn0q0hfVyZp8Z3UhHvOxzMfLX9
	k4cx2oB5vRxOPX8Ftbg+w==
MIME-Version: 1.0
In-Reply-To: <20100719185828.GB32503@redhat.com>
References: <1279560008-2905-1-git-send-email-vgoyal@redhat.com> 
	<1279560008-2905-2-git-send-email-vgoyal@redhat.com> <x49mxtntikn.fsf@segfault.boston.devel.redhat.com> 
	<20100719185828.GB32503@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Mon, 19 Jul 2010 13:32:24 -0700
Message-ID: <AANLkTikqd3VzLSkJfGoN0s29NzhkqJSYSPEEOS2s0TOn@mail.gmail.com>
Subject: Re: [PATCH 1/3] cfq-iosched: Improve time slice charging logic
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, nauman@google.com, guijianfeng@cn.fujitsu.com,
        czoccolo@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 11:58 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Yes it is mixed now for default CFQ case. Whereever we don't have the
> capability to determine the slice_used, we charge IOPS.
>
> For slice_idle=0 case, we should charge IOPS almost all the time. Though
> if there is a workload where single cfqq can keep the request queue
> saturated, then current code will charge in terms of time.
>
> I agree that this is little confusing. May be in case of slice_idle=0
> we can always charge in terms of IOPS.

I agree with Jeff that this is very confusing. Also there are
absolutely no bets that one job may end up getting charged in IOPs for
this behavior while other jobs continue getting charged in timefor
their IOs. Depending on the speed of the disk, this could be a huge
advantage or disadvantage for the cgroup being charged in IOPs.

It should be black or white, time or IOPs and also very clearly called
out not just in code comments but in the Documentation too.
