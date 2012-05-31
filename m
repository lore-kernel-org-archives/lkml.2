Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab2EaPBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab2EaPBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:01:39 -0400
Message-ID: <4FC787BF.3020006@redhat.com>
Date: Thu, 31 May 2012 12:01:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
References: <4FC4D6E2.9060501@redhat.com> <20120529145245.GG29157@aftab.osrc.amd.com> <4FC4E9EB.5030801@redhat.com> <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com> <20120531100005.GC14074@aftab.osrc.amd.com> <4FC748F5.9070709@redhat.com> <20120531121741.GB14515@aftab.osrc.amd.com> <4FC7788C.1070405@redhat.com> <20120531142229.GF14515@aftab.osrc.amd.com> <4FC783EA.80704@redhat.com> <20120531145416.GI14515@aftab.osrc.amd.com>
In-Reply-To: <20120531145416.GI14515@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 31-05-2012 11:54, Borislav Petkov escreveu:
> On Thu, May 31, 2012 at 11:44:58AM -0300, Mauro Carvalho Chehab wrote:
>> It doesn't matter if some drivers use statically-defined grain, while
>> others are dynamic: at the reported event, the grain should be there
>> for both types of drivers.
> 
> And only a small subset of the drivers _reportedly_ change grain
> frequently - the majority of them have a static, seldomly changing
> value. Which means, we don't fill up tracepoint records needlessly which
> seldomly changing values.

Grain is an error property, associated with the error address.
It is as simple as that. It is not a "change grain frequently" type
of thing: each address have its associated grain.

Ok, on _old_ hardware, this used to be constant, but on modern ones,
this is associated with the error type, as Tony already explained.

Don't create a crappy API, just because you want to save 32 bits.
Btw, a "string" grain will spare much more than just 32 bits.

Mauro.

