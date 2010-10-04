Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab0JDFAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 01:00:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44020
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab0JDFAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 01:00:36 -0400
Date: Sun, 03 Oct 2010 22:00:57 -0700 (PDT)
Message-Id: <20101003.220057.59686624.davem@davemloft.net>
To: vladislav.yasevich@hp.com
Cc: drosenberg@vsecurity.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Fix out-of-bounds reading in sctp_asoc_get_hmac()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CA65D0E.6080604@hp.com>
References: <1285969907.2814.49.camel@Dan>
	<4CA65D0E.6080604@hp.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 01 Oct 2010 18:13:34 -0400

> On 10/01/2010 05:51 PM, Dan Rosenberg wrote:
>> The sctp_asoc_get_hmac() function iterates through a peer's hmac_ids
>> array and attempts to ensure that only a supported hmac entry is
>> returned.  The current code fails to do this properly - if the last id
>> in the array is out of range (greater than SCTP_AUTH_HMAC_ID_MAX), the
>> id integer remains set after exiting the loop, and the address of an
>> out-of-bounds entry will be returned and subsequently used in the
>> parent
>> function, causing potentially ugly memory corruption.  This patch
>> resets
>> the id integer to 0 on encountering an invalid id so that NULL will be
>> returned after finishing the loop if no valid ids are found.
>>
>> Signed-off-by: Dan Rosenberg<drosenberg@vsecurity.com>
> 
> Good catch.
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
