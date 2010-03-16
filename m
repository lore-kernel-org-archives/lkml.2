Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab0CPSmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:42:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:60331 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0CPSms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Cj98KDSeVoT7+94ZDKW5bPfCdf76vp+W9fclx7qmiAfrN2bsyqWD1SQVWuWCiOrBjI
         BtX4Z5jqmjvwYYEgQBnSNvGOzWyXtrab0p//dvo3WpalPZzvCIJE5+6fBvJcBdvAjnO8
         LN/k4VAL2o6AvObJV69JzgUPLuzbgRTuKxFac=
Message-ID: <4B9FD11E.5050108@gmail.com>
Date: Tue, 16 Mar 2010 19:42:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.4 Thunderbird/3.1b1
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: regd: sleeping in atomic
References: <4B9F86E9.2030702@gmail.com> <43e72e891003160918x3b7e3c9asf4fc8a9db35ccd8a@mail.gmail.com>
In-Reply-To: <43e72e891003160918x3b7e3c9asf4fc8a9db35ccd8a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 05:18 PM, Luis R. Rodriguez wrote:
> one iteration of call_crda() which happens during module
> initialization and from what I gather I don't think the kernel is
> happy when you mutex_lock on load routines, please correct my foggy
> memory if I am mistaken.

No, using mutex in init/exit module routines is fine. Where do you have 
the information from? There might be problems only with request_module, 
flush_scheduled_work or similar.
