Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab2E3DwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 23:52:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43810 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2E3DwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 23:52:10 -0400
Message-ID: <4FC59968.1060600@wwwdotorg.org>
Date: Tue, 29 May 2012 21:52:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <dongas86@gmail.com>
CC: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH v4 6/6] pinctrl: add pinctrl gpio binding support
References: <1337952980-14621-1-git-send-email-b29396@freescale.com> <1337952980-14621-6-git-send-email-b29396@freescale.com> <4FBFBB74.901@wwwdotorg.org> <CAA+hA=QMe6Yo2aLMBcbkYLDXSagb9L919hjdQaq8TyH4uKh9Mw@mail.gmail.com> <4FC24AA7.9040100@wwwdotorg.org> <20120530030157.GA2235@b29396-Latitude-E6410>
In-Reply-To: <20120530030157.GA2235@b29396-Latitude-E6410>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 09:01 PM, Dong Aisheng wrote:
> On Sun, May 27, 2012 at 09:39:19AM -0600, Stephen Warren wrote:
>> On 05/26/2012 10:52 AM, Dong Aisheng wrote:
>>> On Fri, May 25, 2012 at 10:03 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> On 05/25/2012 07:36 AM, Dong Aisheng wrote:
>> ...
>>>> If we don't do that, [lock ranges[i].gc] I would argue that we
>>>> shouldn't store ranges[i].gc, since it might become invalid - I
>>>> believe the only use of it is withinthis function?
>>>>
>>> In my option, i think it's ok to store it since they're just some data
>>> to describe
>>> hw properties. The gpio function may become invalid but not data.
>>> Is it reasonable to you?
>>
>> The problem is that if someone tries to dereference the gc field, and
>> it's no longer valid, which could cause an OOPS. Perhaps we can get away
>> just with a comment in the struct definition indicating that this field
>> should only be used by drivers that provided the gc field directly
>> rather than having it set up by DT, but then why even store it when
>> creating the ranges from DT in that case?
>
> Yes, you're right.
> Maybe we could both not store the gc filed for DT (currently we did not see
> the need to store it for dt, right?) and add a comment in the struct definition
> as you said. For non-dt users the driver owner should manage that field
> correctly with lock since it's provided directly by driver.
> Is that ok?

Yes, that makes sense to me. Thanks.
