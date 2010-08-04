Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab0HDJVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:21:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52136 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0HDJVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-face:face:x-url:x-pgp-fp
         :x-pgp:date:in-reply-to:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=WLV67kktbHRNiSYzpg5an4RCbBNFjH0+KIttKECg7JHUTEGKjWkpGYbVO5f+wzcmtm
         4PBXZ5PRJU5konez4y726xy9cum3GkzjUkk7E+q5HTDGmvITo+ThxE6l1+Vcd20tFkdh
         nmsUrBtguSK6Au+6xSqLH0hfWlesoGmXib7Ng=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg KH <greg@kroah.com>
Cc: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
        David Brownell <david-b@pacbell.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some gadgets
References: <231296.268.qm@web180308.mail.gq1.yahoo.com>
	<op.vgn0zfyq7p4s8u@pikus> <20100730165450.GA4943@kroah.com>
	<op.vgtl5umt7p4s8u@pikus> <20100802225221.GA12051@kroah.com>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Wed, 04 Aug 2010 11:21:09 +0200
In-Reply-To: <20100802225221.GA12051@kroah.com> (Greg KH's message of "Mon, 2
	Aug 2010 15:52:21 -0700")
Message-ID: <87zkx2vim2.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Aug 02, 2010 at 07:14:08PM +0200, Michał Nazarewicz wrote:
>> One for the Multifunction Composite Gadget (g_multi)

Greg KH <greg@kroah.com> writes:
> You now have device id 0104 reserved for this.

>> and another for FunctionFS Gadget (g_ffs).

> You now have device id 0105 reserved for this.

Great! Thanks.  I'll send patches changing the IDs tomorrow.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
