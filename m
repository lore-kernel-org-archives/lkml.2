Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2JJPdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:33:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35259 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2JJPdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:33:35 -0400
Message-ID: <5075954B.8030008@gmail.com>
Date: Wed, 10 Oct 2012 10:33:31 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: David Gibson <david@gibson.dropbear.id.au>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Scott Wood <scottwood@freescale.com>
Subject: Re: dtc: import latest upstream dtc
References: <1349827466.26044.16@snotra> <ADE80D65-5170-4A8E-8D90-29161F8DB3BB@bsdimp.com> <20121010072401.GA28467@truffula.fritz.box> <50759152.9050407@wwwdotorg.org>
In-Reply-To: <50759152.9050407@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 10:16 AM, Stephen Warren wrote:
> On 10/10/2012 01:24 AM, David Gibson wrote:
>> On Tue, Oct 09, 2012 at 10:43:50PM -0600, Warner Losh wrote:
>>>
>>> On Oct 9, 2012, at 6:04 PM, Scott Wood wrote:
>>>
>>>> On 10/09/2012 06:20:53 PM, Mitch Bradley wrote:
>>>>> On 10/9/2012 11:16 AM, Stephen Warren wrote:
>>>>>> On 10/01/2012 12:39 PM, Jon Loeliger wrote:
>>>>>>>>
>>>>>>>> What more do you think needs discussion re: dtc+cpp?
>>>>>>>
>>>>>>> How not to abuse the ever-loving shit out of it? :-)
>>>>>>
>>>>>> Perhaps we can just handle this through the regular patch review
>>>>>> process; I think it may be difficult to define and agree upon exactly
>>>>>> what "abuse" means ahead of time, but it's probably going to be easy
>>>>>> enough to recognize it when one sees it?
>>>>> One of the ways it could get out of hand would be via "include
>>>>> dependency hell".  People will be tempted to reuse existing .h files
>>>>> containing pin definitions, which, if history is a guide, will end up
>>>>> depending on all sorts of other .h files.
>>>>> Another problem I often face with symbolic names is the difficulty of
>>>>> figuring out what the numerical values really are (for debugging),
>>>>> especially when .h files are in different subtrees from the files that
>>>>> use the definitions, and when they use multiple macro levels and fancy
>>>>> features like concatenation.  Sometimes I think it's clearer just to
>>>>> write the number and use a comment to say what it is.
>>>>
>>>> Both comments apply just as well to ordinary C code, and I don't think anyone would seriously suggest just using comments instead for C code.
>>>
>>> .h files include both structs and defines, which are fine for
>>> ordinary C code, but problematic in this context.
>>
>> Right, cpp should be invoked with similar options to the way it's done
>> for asm files which have the same problem.  I'm not sure if the
>> current patch does so.
> 
> That's probably a reasonable idea, although I imagined that people would
> actually split out the portions of any header file they wanted to use
> with dtc, so that any headers included by *.dts would only include
> #defines. Those headers could be used by both dtc and other .h files (or
> .c files).

Used by what other files? kernel files? We ultimately want to split out
dts files from the kernel, so whatever we add needs to be self
contained. I don't see this as a huge issue though because the whole
point of the DT data is to move that information out of the kernel. If
it is needed in both places, then something is wrong.

Rob
