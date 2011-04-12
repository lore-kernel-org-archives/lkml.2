Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab1DLPqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:46:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab1DLPqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pCEEJGkjsr2bfKj1GJyye+En85VjGJy1EBfmefE17+7o0udVNwqj6oHr9WMTSSNnyl
         WDLJ2cxSSLRwZaWxRzxg==
MIME-Version: 1.0
In-Reply-To: <20110412124155.36787390@lxorguk.ukuu.org.uk>
References: <1302565858-23849-1-git-send-email-natg@google.com>
	<1302565974-23906-1-git-send-email-natg@google.com>
	<20110412124155.36787390@lxorguk.ukuu.org.uk>
Date: Tue, 12 Apr 2011 08:46:26 -0700
Message-ID: <BANLkTikFr+7duu71=yB2rVBKx1SBkmggqg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Use "request_muxed_region" in it87 watchdog drivers
From: Natarajan Gurumoorthy <natg@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>, Mike Waychison <mikew@google.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,
      I looked at your code in kernel/resource.c and I agree the while
is not needed. I guess every time it comes back from "schedule" your
code loops back to reserve the region. I will test the code without
the while and make the needed change.

Regards
Nat

On Tue, Apr 12, 2011 at 4:41 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> +     while (!request_muxed_region(REG, 2, NAME))
>> +             continue;
>> +
>
> This shouldn't need the loop ? - is it only working with the loop
> present ?
>
>
> Otherwise this looks good - I'd just like to understand if the loop was
> needed (indicating a bug has crept into the muxed alloc code somewhere
> perhaps) or not
>
> Alan
>



-- 
Regards
Nat Gurumoorthy AB6SJ
