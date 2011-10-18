Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1JRJHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:07:22 -0400
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:46786 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab1JRJHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:07:21 -0400
Message-ID: <4E9D41C5.70902@Calva.COM>
Date: Tue, 18 Oct 2011 11:07:17 +0200
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Mattia Dongili <malattia@linux.it>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Stelian Pop <stelian@popies.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
References: <4E9ABBF6.3000504@calvaedi.com> <4E9ADBD3.4070404@calvaedi.com> <4E9B182A.3020101@calvaedi.com> <74494.1318789218@turing-police.cc.vt.edu> <20111016213800.GA12703@kamineko.org> <81436.1318801813@turing-police.cc.vt.edu> <20111017214543.GB1311@kamineko.org>
In-Reply-To: <20111017214543.GB1311@kamineko.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/11 23:45, Mattia Dongili wrote:
> On Sun, Oct 16, 2011 at 05:50:13PM -0400, Valdis.Kletnieks@vt.edu wrote:
>    
>> On Mon, 17 Oct 2011 06:38:01 +0900, Mattia Dongili said:
>>      
>> If that's not an option, perhaps we need a per-model quirk that patches up the
>> tables at boot time?  If we do that, we may want to re-arrange the table so the
>> affected entries are at the front or something to help insure we don't patch
>> the wrong entries if somebody else inserts new lines.
>>      
> Wouldn't udev do that already?
> We may actually want to remove those events that never get looked up in
> the tables instead.
>
>    
udev does have some per-model stuff for the Vaio's.

Doesn't work right because the scancodes reported the sony-laptop driver 
are not the right ones.

(sony-laptop sends its "event" code as the scancode, but to change the 
keymap you have to use the index in the sony_laptop_input_keycode_map 
table.  I have posted one patch for this which makes the scancodes at 
least consistent but I think I'll do another that makes them be the same 
as what current udev thinks they should be.  I'll have that ready this 
evening I thing - have to work now :-( )

