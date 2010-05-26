Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab0EZSHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:07:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56732 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0EZSHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Hrm02xY+I3r83KYj2CaJvbgz7ONCBRcLiN8xMEuuX9zPc5UGTQzrRVTvY9AiYE7PRr
         skquDPujSAJWJcoqpJFNa+wVW2AQNDaJWdaCpjR/qqsBl3hxVEaiPU1V93qprffF20yN
         gjYyu0p0w/A83TbgaAIyyBnala5sot9WWEnEc=
MIME-Version: 1.0
In-Reply-To: <1274895611.4467.805.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
	<201005252344.37639.rjw@sisk.pl>
	<AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com>
	<1274863342.5882.4850.camel@twins>
	<20100526112303.3fef15a4@schatten.dmk.lab>
	<1274866402.5882.5051.camel@twins>
	<AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com>
	<1274868384.5882.5169.camel@twins>
	<AANLkTimHGpRAZklIwXu6wEbA3coKXJvCVLxj2twerkCw@mail.gmail.com>
	<1274869262.5882.5222.camel@twins>
	<AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com>
	<1274890736.4467.574.camel@mulgrave.site>
	<AANLkTinv5C-TO48ZMP0ZV-ne7VbCAhXlARhYOJmhYoRa@mail.gmail.com>
	<1274895611.4467.805.camel@mulgrave.site>
Date: Wed, 26 May 2010 21:07:05 +0300
X-Google-Sender-Auth: tkCqysCG7lRsK4b-ejbvqJzGkCU
Message-ID: <AANLkTilKfYLBdlhdvhFY_nQFvCsIX6wpc7VOGOOROBrw@mail.gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 8:40 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>> On Wed, 2010-05-26 at 13:29 +0300, Pekka Enberg wrote:
>> >> Yup, I don't quite get Arve's argument either. C code can interact
>> >> with Java code (and vice versa) just fine in userspace.
>>
>> On Wed, May 26, 2010 at 7:18 PM, James Bottomley
>> <James.Bottomley@suse.de> wrote:
>> > This is an incorrect statement.  It's possible for java to call C via
>> > the JNI, even though there are quite a few gotchas that mean not just
>> > *any* C code can do it (been there, tripped over some of them, although
>> > they were all ultimately ironed out).  It's very difficult for C to call
>> > directly into Java without being specially coded because it involves
>> > creating and managing a JVM (so in general, arbitrary C code can't do
>> > this).  The usual way we do C -> Java is process to process via some
>> > intermediary like RPC or Corba or SOAP (or even JSON) ... which gets
>> > very messy for a mobile device.
>>
>> Incorrect statement how exactly? A JVM can do mmap(), for example,
>> just fine through FileChannel.map() so there's no need for
>> heavy-weight RPC.
>
> Incorrect in that an arbitrary C application can't link to a java API.

Dunno what you mean by "arbitrary" C application but yes, I do agree
that using JNI is somewhat cumbersome. Not sure if that's relevant,
though, as it can all be hidden in the framework APIs.

> mmap and some other messaging (like signals) is just another form of
> IPC ... the list I gave wasn't exhaustive.

The protocols you mentioned are meant for RPC (as in remote) and
messaging, not for IPC which I'm assume is needed for the suspend
manager process Peter is talking about.

>>  Furthermore, the whole discussion is moot anyway as
>> Android runs Dalvik which can be hacked to support whatever
>> communication mechanism is the best choice here.
>>
>> So can we drop the whole "we need to do it in kernel because Java is
>> hard" nonsense and concentrate on real issues?
>
> I've lost you.  This argument seems to hinge on whether or not you
> believe that suspend in any form is a solution to the rogue app
> problem ... whether it's implemented in Java or C is an ancillary issue.

I'm responding to the original argument from Arve that C programs
can't use the existing suspend manager because it's written in Java.
