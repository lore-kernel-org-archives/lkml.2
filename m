Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab0HLKIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 06:08:12 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:59421 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0HLKIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:08:11 -0400
Message-ID: <4C63C807.102@neli.hopto.org>
Date: Thu, 12 Aug 2010 12:08:07 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Kevin Easton <kevin@guarana.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Why is get_user_pages so slow?
References: <4C61AD7A.7040400@neli.hopto.org> <20100812134338.14856uchty1ra39c@guarana.org>
In-Reply-To: <20100812134338.14856uchty1ra39c@guarana.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Kevin Easton wrote:
> Yep, you are.  Because your pointer 'p' is a pointer to int, when you 
> increment it by 0x1000 in your loops you are actually incrementing it by 
> 0x1000 * sizeof(int) - so you're only actually touching one page in four.

Oops sorry, thanks for catching my mistake.

I also discovered the following: if I read from all pages, then call 
get_user_pages, it is still quite slow (did I get a read-only page?). 
However, if I touch all pages by writing to them, then get_user_pages 
becomes a factor 40 times faster or so.

All is clear now, I think. Thanks.

Micha
