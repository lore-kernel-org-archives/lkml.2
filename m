Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2JPEp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:45:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:42888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab2JPEp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:45:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="227435300"
Message-ID: <507CE663.2060502@linux.intel.com>
Date: Mon, 15 Oct 2012 21:45:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        greg@kroah.com, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        mpm@selenic.com, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        tglx@linutronix.de, davem@davemloft.net, mingo@kernel.org,
        DJ Johnston <dj.johnston@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC] random: Account for entropy loss due to overwrites
References: <1344878779-10700-1-git-send-email-hpa@linux.intel.com> <50675038.9000108@zytor.com> <20121016040848.GE17446@thunk.org>
In-Reply-To: <20121016040848.GE17446@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 09:08 PM, Theodore Ts'o wrote:
> On Sat, Sep 29, 2012 at 12:47:04PM -0700, H. Peter Anvin wrote:
>>> -static struct poolinfo {
>>> +static const struct poolinfo {
>>> +	int poolshift;		/* log2(POOLBITS) */
>>>  	int poolwords;
>>>  	int tap1, tap2, tap3, tap4, tap5;
> 
> Poolshift is duplicated information; it's just log2(poolwords) + 5
> (since POOLBITS is poolwords*32).
> 
> Granted you don't want to recalculate it every single time you need to
> use it, but perhaps it would be better to add poolshift to struct
> entropy_store, and set it in init_std_data()?
> 

Or we could compute poolwords (and poolbits, and poolbytes) from it,
since shifts generally are cheap.  I don't strongly care, whatever your
preference is.

	-hpa



