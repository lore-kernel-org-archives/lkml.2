Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab1LHQGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:06:33 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:18069 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1LHQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:06:31 -0500
X-Authority-Analysis: v=2.0 cv=ZPFVaAHb c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=LNmbJxpDd3oA:10 a=8nJEP1OIZ-IA:10 a=3KPRyHfuVZQIHCYAEiAA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4EE0E085.8000907@cfl.rr.com>
Date: Thu, 08 Dec 2011 11:06:29 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <cover.1322709471.git.psusi@cfl.rr.com> <4ED6F320.5060709@cfl.rr.com> <20111208123038.GA16493@nb.redhat.com> <4EE0C814.2000807@cfl.rr.com> <20111208151650.GB16934@nb.redhat.com> <4EE0D6E6.9000807@cfl.rr.com> <20111208155844.GA9281@redhat.com>
In-Reply-To: <20111208155844.GA9281@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/2011 10:58 AM, Vivek Goyal wrote:
> So, if there is an IO in flight while partition shrinking is happening,
> then IO can end up happening outside the partition?

Yes.  Of course if there was an in flight IO at the time you truncate 
the partition, then you did something wrong ( didn't shrink the fs first ).

> part->nr_sects can be 64 bits on 32bit machines and update will be
> non-atomic. I had used sequence counter to make sure read is able
> to get to intermediate value. May be it is a good idea to address
> this concenrn.

Isn't that what the mutex is for?

