Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0D1OyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:54:09 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56011 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab0D1OyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VMLCSmbO32kc3zVRqs/QBHscSXn/JZQ94Zr7SWy1OdYVltPfA1HbP6aGZQXYU6aLts
         ybbaX0qDJjBhej0WgMafA15dBJfQjrf8ZwqXEYM1oXpTNxaz4H5iZ3wQ0Fi32nawB0iG
         Rqbz44BJ/GxaMMZkDMTMwnANT/elS/njBT47M=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1004281349130.9849@pobox.suse.cz>
References: <t2g3711715e1004240718m8aacffc5o68fc9ccd1e66f212@mail.gmail.com>
	 <w2l3711715e1004271145v133cd94ax971aa213eb60cfaa@mail.gmail.com>
	 <alpine.LNX.2.00.1004272242050.9849@pobox.suse.cz>
	 <y2u3711715e1004272206u4700fac7u744b2fb0cf203367@mail.gmail.com>
	 <alpine.LNX.2.00.1004281349130.9849@pobox.suse.cz>
Date: Wed, 28 Apr 2010 16:54:00 +0200
Message-ID: <m2x3711715e1004280754h35225f9ch75cb0be11ab6b75e@mail.gmail.com>
Subject: Re: HID: expand hid-topseed driver to support BTC "Emprex 3009URF III 
	Vista MCE Remote"
From: Wayne Thomas <waynethomas69@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 1:51 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 28 Apr 2010, Wayne Thomas wrote:
>
>> >> OK, next attempt...
>> >
>> > The patch is OK, but your mail client whitespace-damaged it. Could you
>> > please fix up your client and resend? (or attach it separately as an
>> > attachment, if your client can't be fixed).
>> >
>> > Thanks,
>>
>> I thought it might have; sorry about that.
>> Have attached patch as separate file as a precaution.
>
> Thanks for the patch.
>
> What is the reason for it being backwards-compatible with the older
> topspeed device?
>
> Changes such as
>
> -       case 0x048: ts_map_key_clear(KEY_RED);            break;
> +       case 0x05b: ts_map_key_clear(KEY_RED);          break;
>
> (and no other handling of neither 0x048 nor KEY_RED) make me wonder ...
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>

The TopSeed remote has four keys in particular with two labels on each
of them (but only a single output for each key):

- the button with output 0x047 is coloured Green and has the label 'MUSIC'
- the button with output 0x048 is coloured Red and has the label 'DVD/VCD'
- the button with output 0x049 is coloured Yellow and has the label 'PICTURE'
- the button with output 0x04a is coloured Blue and has the label 'VIDEO'

The BTC remote has four buttons with identical outputs and the same
labels but they are not coloured.  The BTC has seperate coloured
buttons with completely different outputs.

The original writer of hid-topseed chose to use the colour of the
TopSeed buttons for his key maps rather than the labels.  If I did not
change this the BTC would effectively loose four buttons as each
coloured button would have the same keymap as the seperate labelled
button (i.e. Music, DVD/VCD, PICTURE, VIDEO).  To prevent this I
altered the original keymaps of the TopSeed to use the appropriate
label, and added the BTC's coloured keymap as seperate buttons.  (I
hope I made sense).

Every original TopSeed button has been represented in the driver (i.e.
I changed case 0x048 to KEY_CAMERA) and I tidied up the order that
they have appeared.  Below I have re-jigged the relevant part of the
patch to help explain (sorry for the whitespace damage that will no
doubt occur).  There are obviously some unneccessary deletions and
re-insertions, this occured due to me starting from scratch.
Ultimately there are four changes and six new entries.

-        case 0x00d: ts_map_key_clear(KEY_HOME);           break;
+       case 0x00d: ts_map_key_clear(KEY_HOME);         break;
-        case 0x024: ts_map_key_clear(KEY_MENU);           break;
+       case 0x024: ts_map_key_clear(KEY_MENU);         break;
-        case 0x025: ts_map_key_clear(KEY_TV);             break;
+       case 0x025: ts_map_key_clear(KEY_TV);           break;
-        case 0x048: ts_map_key_clear(KEY_RED);            break;
+       case 0x048: ts_map_key_clear(KEY_DVD);          break;
-        case 0x047: ts_map_key_clear(KEY_GREEN);          break;
+       case 0x047: ts_map_key_clear(KEY_MP3);          break;
-        case 0x049: ts_map_key_clear(KEY_YELLOW);         break;
+       case 0x049: ts_map_key_clear(KEY_CAMERA);       break;
-        case 0x04a: ts_map_key_clear(KEY_BLUE);           break;
+       case 0x04a: ts_map_key_clear(KEY_VIDEO);        break;
-        case 0x04b: ts_map_key_clear(KEY_ANGLE);          break;
+       case 0x04b: ts_map_key_clear(KEY_ANGLE);        break;
-        case 0x04c: ts_map_key_clear(KEY_LANGUAGE);       break;
+       case 0x04c: ts_map_key_clear(KEY_LANGUAGE);     break;
-        case 0x04d: ts_map_key_clear(KEY_SUBTITLE);       break;
+       case 0x04d: ts_map_key_clear(KEY_SUBTITLE);     break;
-        case 0x031: ts_map_key_clear(KEY_AUDIO);          break;
+       case 0x031: ts_map_key_clear(KEY_AUDIO);        break;
-        case 0x032: ts_map_key_clear(KEY_TEXT);           break;
+       case 0x032: ts_map_key_clear(KEY_TEXT);         break;
-        case 0x033: ts_map_key_clear(KEY_CHANNEL);        break;
+       case 0x033: ts_map_key_clear(KEY_CHANNEL);      break;
+       case 0x050: ts_map_key_clear(KEY_RADIO);        break;
+       case 0x05b: ts_map_key_clear(KEY_RED);          break;
+       case 0x05c: ts_map_key_clear(KEY_GREEN);        break;
+       case 0x05d: ts_map_key_clear(KEY_YELLOW);       break;
+       case 0x05e: ts_map_key_clear(KEY_BLUE);         break;
+       case 0x05a: ts_map_key_clear(KEY_TEXT);         break;

I hope this has answered your question sufficiently.

Cheers
Wayne
