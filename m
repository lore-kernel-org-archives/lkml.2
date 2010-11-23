Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab0KWTSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:18:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45541 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab0KWTSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:18:23 -0500
Date: Tue, 23 Nov 2010 11:16:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Change return type of obvious Boolean list fns to
 "bool".
Message-Id: <20101123111658.8bfb91cd.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.2.00.1011210819350.25385@localhost6.localdomain6>
References: <alpine.DEB.2.00.1011210819350.25385@localhost6.localdomain6>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 08:35:04 -0500 (EST) Robert P. J. Day wrote:

> 
> It's clear that a number of basic list routines return simply a
> Boolean value, so change their return type from "int" to "bool".
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

with allmodconfig on i386 and x86_64.


> ---
> 
>   Compile-tested with defconfig on x86_64.  Not sure who should
> be CCed when a patch touches something this basic.  Andrew?
> 
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 9a5f8a7..1d6ed55 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -167,7 +167,7 @@ static inline void list_move_tail(struct list_head *list,
>   * @list: the entry to test
>   * @head: the head of the list
>   */
> -static inline int list_is_last(const struct list_head *list,
> +static inline bool list_is_last(const struct list_head *list,
>  				const struct list_head *head)
>  {
>  	return list->next == head;
> @@ -177,7 +177,7 @@ static inline int list_is_last(const struct list_head *list,
>   * list_empty - tests whether a list is empty
>   * @head: the list to test.
>   */
> -static inline int list_empty(const struct list_head *head)
> +static inline bool list_empty(const struct list_head *head)
>  {
>  	return head->next == head;
>  }
> @@ -195,7 +195,7 @@ static inline int list_empty(const struct list_head *head)
>   * to the list entry is list_del_init(). Eg. it cannot be used
>   * if another CPU could re-list_add() it.
>   */
> -static inline int list_empty_careful(const struct list_head *head)
> +static inline bool list_empty_careful(const struct list_head *head)
>  {
>  	struct list_head *next = head->next;
>  	return (next == head) && (next == head->prev);
> @@ -219,7 +219,7 @@ static inline void list_rotate_left(struct list_head *head)
>   * list_is_singular - tests whether a list has just one entry.
>   * @head: the list to test.
>   */
> -static inline int list_is_singular(const struct list_head *head)
> +static inline bool list_is_singular(const struct list_head *head)
>  {
>  	return !list_empty(head) && (head->next == head->prev);
>  }


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
