Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0FXJ1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:27:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:31807 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0FXJ1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=GdP8o7RCoN1rqYEnZWbgxF/wid5XbSirEbn5cmakIIAzmDqfFeN+T8O9HqzvlAg+qM
         0mfZcUce4gZuuflgjYzefBiyR1blIcni5/Gijk+CA/a5s0j7FiEOoF6saJMc9u56isH2
         ocl7B0syeswokZQz53iOWDx4o3rooKRHHLp4s=
Subject: Re: [PATCH 1/2] Staging: memrar: Moved memrar_allocator struct to memrar_allocator.c
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: "=?iso-8859-1?Q?Henri_H=E4kkinen?=" <henrih81@gmail.com>
In-Reply-To: <20100624101618.51dea6d5@lxorguk.ukuu.org.uk>
Date: Thu, 24 Jun 2010 12:27:43 +0300
Cc: gregkh@suse.de, ossama.othman@intel.com,
       Matti Lammi <mattij.lammi@gmail.com>, randy.dunlap@oracle.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0F091BB6-3DD4-48F2-B8AF-EDC02ECC4DE8@gmail.com>
References: <1277363386-4817-1-git-send-email-henuxd@gmail.com> <20100624101618.51dea6d5@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.6.2010, at 12.16, Alan Cox wrote:

>> +size_t memrar_allocator_largest_free_area(struct memrar_allocator *allocator)
>> +{
>> +	if (allocator == NULL)
>> +		return 0;
>> +	return allocator->largest_free_area;
>> +}
> 
> static ?

The entire point of these two patches was to hide the memrar_allocator structure by moving it to memrar_allocator.c, forward declaring it in memrar_allocator.h and then providing accessor functions memrar_allocator_largest_free_area and memrar_allocator_capacity (this was the #2 issue for memrar_allocator.[ch] in the TODO file). By defining memrar_allocator_largest_free_area function as static (this is what you mean, right?) would make no sense.

