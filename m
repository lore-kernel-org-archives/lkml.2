Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0CXVlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:41:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:16863 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0CXVk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=p9vv52lQvFqYtPmYXsjyaC5W21L8+VpBjIv4lLwJfRibSs/E+ezMu4YJMUghPIFI9V
         gZquSvIvEsmc0amxrDB2wfU97uQTieOtjn++NkFN7KAxHyIc1611l46nB+du1C2Q7CKa
         H0p3CI658jzJLJ1u0XqCWOQ9raaF+TCFagTqU=
Message-ID: <4BAA86E8.5090108@gmail.com>
Date: Wed, 24 Mar 2010 22:40:56 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.9 Thunderbird/3.1b1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 09/15] PM / Hibernate: user, implement user_ops writer
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-9-git-send-email-jslaby@suse.cz> <20100324204259.GA6423@elf.ucw.cz>
In-Reply-To: <20100324204259.GA6423@elf.ucw.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 09:42 PM, Pavel Machek wrote:
>> +	if (test_bit(TODO_CLOSED, to_do_flags))
>> +		return -EIO;
>> +
>> +	to_do_buf = buf;
>> +	wmb();
>> +	set_bit(TODO_WORK, to_do_flags);
>> +	wake_up_interruptible(&to_do_wait);
> 
> Uhuh, open-coded barriers... these need to be commented, and I guess
> you just should not play this kind of trickery.

It's just to ensure the to_do_buf store is not reordered with the
set_bit. I wanted to avoid locks as too heavy tools here.

thanks,
-- 
js
