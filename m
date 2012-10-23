Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2JWEvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:51:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:43940 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750885Ab2JWEvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:51:03 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19cbgF8o4ZcypurEMbKmdhDjWfEoLtnWl2avSqtqb
	yCEobjIc8Pmf0S
Message-ID: <50862224.60908@gmx.de>
Date: Tue, 23 Oct 2012 04:50:44 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120922 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 4/5] xen-fbfront: handle backend CLOSED without CLOSING
References: <507FD39F.4060601@citrix.com> <1350554618-14582-4-git-send-email-david.vrabel@citrix.com> <20121019130011.GD26830@phenom.dumpdata.com>
In-Reply-To: <20121019130011.GD26830@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On 10/19/2012 01:00 PM, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 18, 2012 at 11:03:37AM +0100, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> Backend drivers shouldn't transistion to CLOSED unless the frontend is
>> CLOSED.  If a backend does transition to CLOSED too soon then the
>> frontend may not see the CLOSING state and will not properly shutdown.
>>
>> So, treat an unexpected backend CLOSED state the same as CLOSING.
>>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>> Cc: linux-fbdev@vger.kernel.org
>> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> 
> Hey Florian,
> 
> Should I prep a git pull for you with this or would it be OK
> if I just have your Ack to put this in my git pull for Linus?

Feel free to take it and add
Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>


Best regards,

Florian Tobias Schandinat

> 
> Thanks!
>> ---
>>  drivers/video/xen-fbfront.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
>> index b7f5173..917bb56 100644
>> --- a/drivers/video/xen-fbfront.c
>> +++ b/drivers/video/xen-fbfront.c
>> @@ -641,7 +641,6 @@ static void xenfb_backend_changed(struct xenbus_device *dev,
>>  	case XenbusStateReconfiguring:
>>  	case XenbusStateReconfigured:
>>  	case XenbusStateUnknown:
>> -	case XenbusStateClosed:
>>  		break;
>>  
>>  	case XenbusStateInitWait:
>> @@ -670,6 +669,10 @@ InitWait:
>>  		info->feature_resize = val;
>>  		break;
>>  
>> +	case XenbusStateClosed:
>> +		if (dev->state == XenbusStateClosed)
>> +			break;
>> +		/* Missed the backend's CLOSING state -- fallthrough */
>>  	case XenbusStateClosing:
>>  		xenbus_frontend_closed(dev);
>>  		break;
>> -- 
>> 1.7.2.5
> 

