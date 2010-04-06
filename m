Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab0DFXly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:41:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48838 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789Ab0DFXln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:41:43 -0400
Message-ID: <4BBBC470.4050002@zytor.com>
Date: Tue, 06 Apr 2010 16:32:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Youngwhan Song <breadncup@gmail.com>
CC: Venkatram Tummala <venkatram867@gmail.com>,
       Joel Fernandes <agnel.joel@gmail.com>,
       Frank Hu <frank.hu.2001@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-kernel@zh-kernel.org" <linux-kernel@zh-kernel.org>,
       "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>  	<g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>  	<4BBB7AC9.5060008@zytor.com> <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>  	<4BBB8F07.60401@zytor.com> <w2p9ff7a3bc1004061301v6cc76e1g1e573468b1b8807d@mail.gmail.com> 	<q2iacff6c2b1004061528t28f1337eq977aabf8fe71bc22@mail.gmail.com> <3715922601579231267@unknownmsgid>
In-Reply-To: <3715922601579231267@unknownmsgid>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 04:27 PM, Youngwhan Song wrote:
> Nice explanation, Venkatram,
> 
> Just one question pop up mind.
> 
> What if actual physical memory is only 256MB? How does kernel divide
> virtual memory? Do we need to specify the region to kernel? Or will
> kernel itself decide it automatically? 
> 

If there is less than 896 MB of physical memory, the vmalloc region is
automatically extended (in your case, it will be 768 MB in size.)  There
will be no HIGHMEM in such a case, and if you are compiling your own
kernel you will gain considerable speed by disabling HIGHMEM support
completely.

This, of course, was the norm back when Linux was first created, and a
typical amount of memory was 8 MB or so.  That we'd have gigabytes of
memory seemed very distant at the time.

	-hpa
