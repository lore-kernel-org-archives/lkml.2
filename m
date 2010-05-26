Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056Ab0EZRZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:25:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:22443 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab0EZRZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KnAHsPd2HiwHqVTz3dNIQ/ysH0yZmXWy78QN8sWebqA/hFJe/7TDroIMkqu3VZl66R
         eE1rZyhEDFNroskGGn27sxOveaJ/Oz/Mq5vasSRgSj3Je3tg5cRGymceofV6iJe/nEo/
         9tyEsfJ9csdVe09raS/4iTl4b9p5+DCw2IP7Q=
MIME-Version: 1.0
In-Reply-To: <1274890736.4467.574.camel@mulgrave.site>
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
Date: Wed, 26 May 2010 20:25:15 +0300
X-Google-Sender-Auth: tB4rNgi_MQmUBGaqz0tZgEeoPis
Message-ID: <AANLkTinv5C-TO48ZMP0ZV-ne7VbCAhXlARhYOJmhYoRa@mail.gmail.com>
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

Hi James,

On Wed, 2010-05-26 at 13:29 +0300, Pekka Enberg wrote:
>> Yup, I don't quite get Arve's argument either. C code can interact
>> with Java code (and vice versa) just fine in userspace.

On Wed, May 26, 2010 at 7:18 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> This is an incorrect statement.  It's possible for java to call C via
> the JNI, even though there are quite a few gotchas that mean not just
> *any* C code can do it (been there, tripped over some of them, although
> they were all ultimately ironed out).  It's very difficult for C to call
> directly into Java without being specially coded because it involves
> creating and managing a JVM (so in general, arbitrary C code can't do
> this).  The usual way we do C -> Java is process to process via some
> intermediary like RPC or Corba or SOAP (or even JSON) ... which gets
> very messy for a mobile device.

Incorrect statement how exactly? A JVM can do mmap(), for example,
just fine through FileChannel.map() so there's no need for
heavy-weight RPC. Furthermore, the whole discussion is moot anyway as
Android runs Dalvik which can be hacked to support whatever
communication mechanism is the best choice here.

So can we drop the whole "we need to do it in kernel because Java is
hard" nonsense and concentrate on real issues?

                               Pekka
