Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0EYWt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:49:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55270 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0EYWt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:49:56 -0400
Message-ID: <4BFC53FF.1030106@zytor.com>
Date: Tue, 25 May 2010 15:49:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Yinghai <yinghai.lu@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, jkosina@novell.com
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEAF9B6.2040606@zytor.com> <4BEB0D5F.8070806@oracle.com> <4BEB1781.1080907@sgi.com> <4BEC6C94.2020100@sgi.com> <4BEC73B2.2020909@oracle.com> <4BEC7544.1080506@sgi.com> <4BEC8161.6050206@zytor.com> <4BFC5080.6030103@sgi.com> <4BFC5217.6060804@zytor.com> <4BFC5330.5080907@sgi.com>
In-Reply-To: <4BFC5330.5080907@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2010 03:46 PM, Mike Travis wrote:
> 
> I wondered about that. Sanitize seems to remove adjacent
> entries, etc. making the map smaller, but I couldn't detect
> any real differences (though admittedly I didn't do a byte
> by byte comparison.)
> 
> But I'll submit another with that call removed.
> 

Sanitize in particular tries to make sense of an otherwise-messed-up
map.  This means that if we find a system where it does something
broken, we don't have a way to get the raw data to check what it did!

	-hpa
