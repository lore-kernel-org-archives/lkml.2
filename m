Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0KZEte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 23:49:34 -0500
Received: from rs35.luxsci.com ([66.216.127.90]:57566 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab0KZEtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 23:49:31 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 23:49:31 EST
Message-ID: <4CEF3AB1.9060200@firmworks.com>
Date: Thu, 25 Nov 2010 18:42:25 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Grant Likely <grant.likely@secretlab.ca>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        sparclinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: Mega rename of device tree routines from of_*() to dt_*()
References: <1290607413.12457.44.camel@concordia>	<1290692075.689.20.camel@concordia>	<AANLkTiknyKi1pzvUP2WnasudZwH27-a0FxCX0BSHBdQp@mail.gmail.com> <1290741341.9453.377.camel@concordia>
In-Reply-To: <1290741341.9453.377.camel@concordia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 5:15 PM, Michael Ellerman wrote:
> On Thu, 2010-11-25 at 09:17 -0700, Grant Likely wrote:
>> On Thu, Nov 25, 2010 at 6:34 AM, Michael Ellerman
>> <michael@ellerman.id.au>  wrote:
>>> On Thu, 2010-11-25 at 01:03 +1100, Michael Ellerman wrote:
>>>> Hi all,
>>>>
>>>> There were some murmurings on IRC last week about renaming the of_*()
>>>> routines.
>>> ...
>>>> The thinking is that on many platforms that use the of_() routines
>>>> OpenFirmware is not involved at all, this is true even on many powerpc
>>>> platforms. Also for folks who don't know the OpenFirmware connection
>>>> it reads as "of", as in "a can of worms".
>>> ...
>>>> So I'm hoping people with either say "YES this is a great idea", or "NO
>>>> this is stupid".
>>>
>>> I'm still hoping, but so far it seems most people have got better things
>>> to do, and of those that do have an opinion the balance is slightly
>>> positive.
>>
>> I assume you'll be also publishing the script that you use for
>> generating the massive patch.  I expect that there will be a few
>> iterations of running the rename script to convert over all the
>> stragglers.
>
> Yep sure, I'll just make it less crap first.
>
>> It should also be negotiated with Linus about when this
>> patch should get applied.  I do NOT want to cause massive merge pain
>> during the merge window.
>
> Obviously.
>
>> Andrew/Linus: Before Michael proceeds too far with this rename, are
>> you okay with a mass rename of the device tree functions from of_* to
>> dt_*?  Nobody likes the ambiguous 'of_' prefix ("of?  of what?"), but
>> to fix it means large cross-tree patches and potential merge
>> conflicts.
>
> It'd also be good to hear from DaveM, sparc is the platform with the
> strongest link to real OF AFAIK, so the of_() names make more sense
> there.


One Laptop Per Child ships real Open Firmware on its x86 Linux systems, 
of which approximately 2 million have been shipped or ordered.  An ARM 
version, also with OFW, is in the works.  From the standpoint of "number 
of units in the field actually running Linux", I expect that compares 
favorably with SPARC.

That said, I don't particularly like the abbreviation "of" either; I 
abbreviate Open Firmware as "OFW".

I don't mind using "dt_" to apply to device tree things; I think it's 
clearer than "of_".   Ideally, it would be nice to acknowledge the 
historical connection in some way, but confusing nomenclature probably 
is not the way to go about it.



>
>>> So here's a first cut of a patch to add the new names. I've not touched
>>> of_platform because that is supposed to go away. That will lead to some
>>> odd looking code in the interim, but I think is the right approach.
>>
>> I would split it up into separate dt*.h files, one for each of*.h file
>> so that the #include lines can be changed in the C code at the same
>> time.  Each dt*.h file would include it's of*.h counterpart.  Then
>> after the code is renamed, and a release or two has passed to catch
>> the majority of users, the old definitions can be moved into the dt*.h
>> files.
>
> Yep that sounds like a plan. I did it as a single header for starters so
> I could autogenerate the rename script easily.
>
>> However, it may be better to move and rename the definitions
>> immediately, and leave "#define of_*  dt_*" macros in the old of*.h
>> files which can be removed with a simple patch after all the users are
>> converted.  That would have a smaller impact in the cleanup stage.
>
> True, though a bigger impact to start with. I did that originally but
> decided it might be better to start with the minimal patch to add the
> new names. That way Linus might accept it this release, meaning we'd
> have the new names in place for code in -next.
>
>>> Most of these are straight renames, but some have changed more
>>> substantially. The routines for the flat tree have all become fdt_foo().
>>> I'd be inclined to drop "early_init" from them too, because they're
>>> basically all about early init, but Grant said he'd prefer not to I
>>> think. I've also renamed the flat tree tag constants to match libfdt.
>>
>> It is all about early init now in Linus' tree, but Stephen
>> Neuendorffer has patches that use the fdt code at driver probe time
>> for parsing device tree fragments that describe an FPGA add-in board.
>
> OK fair enough.
>
>>> I've left for_each_child_of_node(), because I read it as "of", but maybe
>>> it's "OF"?
>>
>> hahaha!  I never considered that it might be OF, but now I probably
>> won't be able to help but read it that way!  I like Geert's suggestion
>> of dt_for_each_child_node
>
> OK, I like it the way it is, but if the consensus is to change it then
> we can. There's a bunch actually:
>
> for_each_node_by_name(dn, name) \
> for_each_node_by_type(dn, type) \
> for_each_compatible_node(dn, type, compatible) \
> for_each_matching_node(dn, matches) \
> for_each_child_of_node(parent, child) \
> for_each_node_with_property(dn, prop_name) \
>
> So either dt_for_each_blah(), or for_each_dt_node_blah() ?
>
>>> /* include/linux/device.h */
>>> #define dt_match_table                  of_match_table
>>> #define dt_node                         of_node
>>
>> This could be very messy.  I've nervous about using #define to rename
>> structure members.  You'll need to check that any structure members
>> that use the same name as a global symbol are handled appropriately.
>
> I'm not sure what you mean about global symbols.
>
> I think it's fairly safe, in that direction, ie. defining the dt_*
> names. Neither of those strings appears anywhere in the tree at the
> moment (as a token).
>
> cheers
>
>
>
>
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
