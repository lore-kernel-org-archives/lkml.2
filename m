Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab0EZK3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:29:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42412 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab0EZK3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FKDyTcWvjNeRfLbXJAvhEQCt6yOI+K6Ku67ZCfE/CNUEznfFipIcOA38ZilLKNpt8+
         +JA1gGT+sC7gp0+4eABisbaJOTYVtybeBy1XUT5MaqFi9I6tiZ4VLzJBlqV7gqMJJB+k
         0q3QkQRGeSWbRYgR3U1/4y6cS07/13e8emIRk=
MIME-Version: 1.0
In-Reply-To: <1274869262.5882.5222.camel@twins>
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
Date: Wed, 26 May 2010 13:29:00 +0300
X-Google-Sender-Auth: nw8bQ7e8s4zHwmU3oZtXYLpzrm4
Message-ID: <AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
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
       tytso@mit.edu, James Bottomley <James.Bottomley@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 03:17 -0700, Arve Hjønnevåg wrote:
>> > With a single suspend manager process that manages the suspend state you
>> > can achieve the same goal.
>>
>> Yes we don't need the /dev interface, but it is useful. Without it any
>> program that needs to block suspend has to make a blocking ipc call
>> into the suspend manager process. Android already does this for java
>> code, but system processes written in C block suspend directly with
>> the kernel since they cannot use the java APIs.

2010/5/26 Peter Zijlstra <peterz@infradead.org>:
> So provide a C interface to it as well?
>
> Surely you can have the java thing have a unix socket or something a C
> app can talk to. That shouldn't be hard at all.
>
> Or make the suspend manager a C proglet and provide a JNI interface, or
> whatever.

Yup, I don't quite get Arve's argument either. C code can interact
with Java code (and vice versa) just fine in userspace.
