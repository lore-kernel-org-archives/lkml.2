Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0HKHf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:35:56 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:50004 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752951Ab0HKHfz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:35:55 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Date: Wed, 11 Aug 2010 00:35:51 -0700
Subject: Re: [PATCH 1/2] param: allow omitting set() methods for truly
 read-only params
Thread-Topic: [PATCH 1/2] param: allow omitting set() methods for truly
 read-only params
Thread-Index: Acs5J9QzM7R/aGKiQwuiQNRBczJuZw==
Message-ID: <6889404B-C389-4421-BDD7-A042DAAB064A@vmware.com>
References: <1281466725-22549-1-git-send-email-dtor@vmware.com>
 <201008111109.30433.rusty@rustcorp.com.au>
In-Reply-To: <201008111109.30433.rusty@rustcorp.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 10, 2010, at 6:39 PM, "Rusty Russell" <rusty@rustcorp.com.au>  
wrote:

> On Wed, 11 Aug 2010 04:28:44 am Dmitry Torokhov wrote:
>> Certain "parameters", such as acpica version and upcoming VMware  
>> Balloon
>> version, are need to be purely read-only. They are exported as
>> parameters so that they are visible in sysfs even in cases when the
>> module is built directly into the kernel, but their values should be
>> immutable. Specifying S_IRUGO takes care of sysfs interface, but it
>> has no effect on kernel command line or modprobe configuration  
>> files and
>> so these "parameters" attempt to omit set() method. Unfortunately
>> kernel expects set() to be always present and crashes if it is not
>> there, so let's add appropriate check.
>>
>> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
>
> That almost makes sense, but not quite.
>
> Your followup patch uses this for version, but the version is already
> in /sys/module/vmware_balloon/version as is standard with modules, no?
>

That version attribute is not present if the driver is built-in, only  
parameters are visible in both cases.

-- 
Dmitry

