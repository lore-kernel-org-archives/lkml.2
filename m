Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab0JFMtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 08:49:55 -0400
Received: from mx1.melware.net ([78.47.171.162]:60805 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799Ab0JFMty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 08:49:54 -0400
Date: Wed, 6 Oct 2010 14:49:52 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Dan Carpenter <error27@gmail.com>
cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] eicon: make buffer larger
In-Reply-To: <20101006121119.GA11681@bicker>
Message-ID: <alpine.DEB.2.00.1010061443480.30674@justus.melware.de>
References: <20101004192459.GE5692@bicker> <alpine.DEB.2.00.1010060923120.29107@justus.melware.de> <20101006074714.GE5409@bicker> <alpine.DEB.2.00.1010061019480.29404@justus.melware.de> <20101006083117.GF5409@bicker> <alpine.DEB.2.00.1010061043550.29582@justus.melware.de>
 <20101006121119.GA11681@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Dan Carpenter wrote:
> On Wed, Oct 06, 2010 at 10:44:47AM +0200, Armin Schindler wrote:
>>>   927    strcpy (clients[id].drvName,     tmp);
>>>   928    strcpy (clients[id].Dbg.drvName, tmp);
>>>                               ^
>>>                    this buffer is only 16 chars
>>
>> Now I understand. You are right. So the fix would be to change these
>> strcpy() to e.g. strncpy() or similar.
>>
>
> We need more than 16 characters to store the information.  What is the
> problem with just making the buffer larger?

The larger buffer is not really needed. Later versions of the driver will 
use the strcpy/memcpy with checked size anyway.
I just want to avoid a change in the debug structure which is used in more than one module/tool.

But it shouldn't be a real problem.

Armin


