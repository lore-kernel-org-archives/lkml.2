Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444Ab0EYSeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:34:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27088 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab0EYSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:34:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=is+eCGIl/MI8hS+Ck12zHlqktXCS2bPtxBVLMvsP5kG6AVYXUAVzyxBjmIHLyzAgD
	4wRD/9tMMVnWFGe23fU3A==
MIME-Version: 1.0
In-Reply-To: <20100525165334.GA27307@redhat.com>
References: <1274227488.2370.107.camel@w-sridhar.beaverton.ibm.com>
	<AANLkTinsrFoLVKDFM5pcKcL_6MvAzhR6IzbNmWKh3BDh@mail.gmail.com>
	<20100525165334.GA27307@redhat.com>
Date: Tue, 25 May 2010 11:34:12 -0700
Message-ID: <AANLkTilawCLv5_XlStsFdOdLh-dmlIR3aUTyrVS-JF_s@mail.gmail.com>
Subject: Re: [PATCH 1/3] cgroups: Add an API to attach a task to current 
	task's cgroup
From: Paul Menage <menage@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sridhar Samudrala <samudrala.sridhar@gmail.com>,
       netdev <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 9:53 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Thu, May 20, 2010 at 03:22:15PM -0700, Paul Menage wrote:
>> On Tue, May 18, 2010 at 5:04 PM, Sridhar Samudrala
>> <samudrala.sridhar@gmail.com> wrote:
>> > Add a new kernel API to attach a task to current task's cgroup
>> > in all the active hierarchies.
>> >
>> > Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
>>
>> Reviewed-by: Paul Menage <menage@google.com>
>>
>> It would be more efficient to just attach directly to current->cgroups
>> rather than potentially creating/destroying one css_set for each
>> hierarchy until we've completely converged on current->cgroups - but
>> that would require a bunch of refactoring of the guts of
>> cgroup_attach_task() to ensure that the right can_attach()/attach()
>> callbacks are made. That doesn't really seem worthwhile right now for
>> the initial use, that I imagine isn't going to be
>> performance-sensitive.
>>
>> Paul
>
> Is this patch suitable for 2.6.35?

Should be OK, yes.

Paul
