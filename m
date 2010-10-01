Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0JAQUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:20:53 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:34175 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753092Ab0JAQUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:20:51 -0400
X-Quarantine-ID: <GYOG0tgtnI9l>
X-Amavis-Alert: BAD HEADER, Improper folded header field made up entirely of
	whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n jycPrvgA\n\t\n
	R1goSzOnkp14Y[...]
Subject: Re: Introduce support for little endian PowerPC
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        Ian Munsie <imunsie@au1.ibm.com>
In-Reply-To: <1285935283.2463.78.camel@pasglop>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
	 <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com>
	 <1285935283.2463.78.camel@pasglop>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Oct 2010 18:20:41 +0200
Message-ID: <1285950041.15020.272.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2010-10-01 at 22:14 +1000, Benjamin Herrenschmidt wrote: 
> 
> Now, the main reasons in practice are anything touching graphics.
> 
> There's quite a few IP cores out there for SoCs that don't have HW
> swappers, and -tons- of more or less ugly code that can't deal with non
> native pixel ordering (hell, even Xorg isn't good at it, we really only
> support cards that have HW swappers today).

That's not true. Even the radeon driver doesn't really need the HW
swappers anymore with KMS.


> There's an even bigger pile of application code that deals with graphics
> without any regard for endianness and is essentially unfixable.

Out of curiosity, what kind of APIs are those apps using? X11 and OpenGL
have well-defined semantics wrt endianness, allowing the drivers to
handle any necessary byte swapping internally, and IME the vast majority
of apps handle this correctly.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
