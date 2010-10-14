Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0JNA3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:29:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59073 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0JNA3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JySMwZ+DPneoijumWUe4B0KLnOzkTAQeXzRSqWFHRuuU1OoxyGLXW3lAykliDJnaz/
         Mg7iilWJCeL2psetY2jG+Dt+AsxicORBTcf+QzS8cSlht/xcSKMyx8fQUOHEvr4YdP5A
         cUsFtUqsT94g7hcvpAyyDma6PfXXgpWguzYVA=
MIME-Version: 1.0
In-Reply-To: <1287015899.10264.394.camel@mulgrave.site>
References: <1286977551.2969.22.camel@mulgrave.site>
	<AANLkTimUT37LfmnU8Rc0+K8r+owCp9e_VyriDHRyuuhr@mail.gmail.com>
	<1287015899.10264.394.camel@mulgrave.site>
Date: Wed, 13 Oct 2010 17:29:06 -0700
Message-ID: <AANLkTi=YH_-Oar15Yd1jW0yz7SL3x=FQxMpZ+ppZx6D4@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI bug fixes for 2.6.36-rc7
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 5:24 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Wed, 2010-10-13 at 16:49 -0700, Linus Torvalds wrote:
>> On Wed, Oct 13, 2010 at 6:45 AM, James Bottomley
>> <James.Bottomley@suse.de> wrote:

>>
>> Umm. That other patch seems to be utter crap.
>>
>> > -       hdr->device_status = status_byte(rq->errors);
>> > +       hdr->device_status = rq->errors && 0xff;
>>
>> That's pure shit. Please look at it for one second, and don't send me
>> crap like this.
>
> What's wrong with it? device_status() is an ancient SCSI-1 macro that
> dates from the time the status was left shifted by 1, which makes the
> value wrong according to the sg interface spec.  We should really remove
> it, but there's still a few ancient drivers using it.  the SG interface
> requires the full status byte, which is what the bottom most byte of
> req_errors is ... hence the change.
>

How about & instead of &&

Harvey
