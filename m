Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab0DHRCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:02:08 -0400
Received: from claw.goop.org ([74.207.240.146]:34393 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158Ab0DHRCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:02:03 -0400
Message-ID: <4BBE0C07.1000306@goop.org>
Date: Thu, 08 Apr 2010 10:01:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Avi Kivity <avi@redhat.com>, Dmitry Torokhov <dtor@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com> <20100405142419.2c9bea3d.akpm@linux-foundation.org> <20100405225833.GA25970@dtor-ws.eng.vmware.com> <4BBB622F.4070501@redhat.com> <4BBB7CA3.2060802@goop.org> <4BBB7F1E.3030307@redhat.com> <4BBB890E.5040808@goop.org> <20100408053024.GA1472@ucw.cz>
In-Reply-To: <20100408053024.GA1472@ucw.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 10:30 PM, Pavel Machek wrote:
> Hi!
>
>   
>>>> 1) is not a huge amount of code, but something consistent would be  
>>>> nice.  2) is something we've been missing and is a bit of an open  
>>>> question/research project anyway.
>>>>         
>>> 3) Code that attempts to reclaim 2MB pages when possible
>>>       
>> Yes.  Ballooning in 4k units is a bit silly.
>>     
> Does it make sense to treat ballooning as a form of memory hotplug? 
>   

It has some similarities.  The main difference is granularity;
ballooning works in pages (typically 4k, but 2M probably makes more
sense), whereas memory hotplug works in DIMM-like sizes (256MB+). 
That's way too coarse for us; a domain might only have 256MB or less to
start with.

I experimented with a sort of hybrid scheme, in which I used hotplug
memory to add new struct pages to the system, but only incrementally
populated the underlying pages with the balloon driver.  That worked
pretty well, but it doesn't fit very well with how memory hotplug works
(at least when I last looked at it a couple of years ago).

    J
