Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2DRXHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:07:48 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24085 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2DRXHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:07:47 -0400
Date: Thu, 19 Apr 2012 01:07:45 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: anirudh bhat <abhat38@gmail.com>
cc: arve@android.com, dhowells@redhat.com, chris+android@zenthought.org,
        hpa@zytor.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        anirudh bhat <anirudhbhat@ubuntu.ubuntu-domain>
Subject: Re: [PATCH 2/2] staging:android:fix line over 80 characters issue
 in binders.c this patch fixes line over 80 characters warning that was found
 using checkpatch.pl tool Signed-off-by:Anirudh Bhat <abhat38@gmail.com>
In-Reply-To: <1334769639-5914-1-git-send-email-abhat38@gmail.com>
Message-ID: <alpine.LNX.2.00.1204190026110.14916@swampdragon.chaosbits.net>
References: <1334769639-5914-1-git-send-email-abhat38@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, anirudh bhat wrote:

> From: anirudh bhat <anirudhbhat@ubuntu.ubuntu-domain>
> 
Unless you are sending a patch on behalf of someone else, and need to 
preserve that person as the author of the patch, there's usually no need 
for a From: in the body of your patch submission email - the From: from 
the email headers will be used.

This is where your Signed-off-by: should have been, *not* in the patch 
subject that will usually be used as the initial/summary line of the git
commit message. Which is also why it should usually be kept fairly short - 
yours is extremely long - 164 characters if we exclude the misplaced 
Signed-off-by.

To quote Documentation/SubmittingPatches (which I suggest you read in 
full):

"For these reasons, the "summary" must be no more than 70-75
 characters, and it must describe both what the patch changes, as well
 as why the patch might be necessary.  It is challenging to be both
 succinct and descriptive, but that is what a well-written summary
 should do."

Ohh and one other little detail about that Signed-off-by: 
in the Subject - there should be a space between the colon and name - as 
in "Signed-off-by: Anirudh Bhat <abhat38@gmail.com>".

And finally, your subject is simply wrong.
It does not fix any checkpatch.pl warnings about lines over 80 characters 
as it claims. What it actually does is address 10 out of the current 46 
warnings about "quoted string split across lines" and the 3 warnings about 
"static const char * array should probably be static const char * const". 
But that's not what the Subject says at all.

> ---
>  drivers/staging/android/binder.c |   59 +++++++++++++++++++-------------------
>  1 file changed, 30 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index c283212..ae341e0 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -644,8 +644,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
>  		goto free_range;
>  
>  	if (vma == NULL) {
> -		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
> -		       "map pages in userspace, no vma\n", proc->pid);
> +		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> +			proc->pid);
>  		goto err_no_vma;
>  	}
>  
> @@ -657,8 +657,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
>  		BUG_ON(*page);
>  		*page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>  		if (*page == NULL) {
> -			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
> -			       "for page at %p\n", proc->pid, page_addr);
> +			printk(KERN_ERR "binder: %d: binder_alloc_buf failed for page at %p\n",
> +				proc->pid, page_addr);
>  			goto err_alloc_page_failed;
>  		}
>  		tmp_area.addr = page_addr;
> @@ -666,18 +666,16 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
>  		page_array_ptr = page;
>  		ret = map_vm_area(&tmp_area, PAGE_KERNEL, &page_array_ptr);
>  		if (ret) {
> -			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
> -			       "to map page at %p in kernel\n",
> -			       proc->pid, page_addr);
> +			printk(KERN_ERR "binder: %d: binder_alloc_buf failed to map page at %p in kernel\n",
> +				proc->pid, page_addr);
>  			goto err_map_kernel_failed;
>  		}
>  		user_page_addr =
>  			(uintptr_t)page_addr + proc->user_buffer_offset;
>  		ret = vm_insert_page(vma, user_page_addr, page[0]);
>  		if (ret) {
> -			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
> -			       "to map page at %lx in userspace\n",
> -			       proc->pid, user_page_addr);
> +			printk(KERN_ERR "binder: %d: binder_alloc_buf failed to map page at %lx in userspace\n",
> +				proc->pid, user_page_addr);
>  			goto err_vm_insert_page_failed;
>  		}
>  		/* vm_insert_page does not seem to increment the refcount */
> @@ -733,8 +731,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
>  		ALIGN(offsets_size, sizeof(void *));
>  
>  	if (size < data_size || size < offsets_size) {
> -		binder_user_error("binder: %d: got transaction with invalid "
> -			"size %zd-%zd\n", proc->pid, data_size, offsets_size);
> +		binder_user_error("binder:%d:transaction with invalid size %zd-%zd\n",
> +					proc->pid, data_size, offsets_size);

The space that used to be after "binder:" is gone in your version :(


>  		return NULL;
>  	}
>  
> @@ -762,8 +760,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
>  		}
>  	}
>  	if (best_fit == NULL) {
> -		printk(KERN_ERR "binder: %d: binder_alloc_buf size %zd failed, "
> -		       "no address space\n", proc->pid, size);
> +		printk(KERN_ERR "binder: %d: binder_alloc_buf size %zd failed,no address space\n",
> +			proc->pid, size);

You have killed the space after the comma in the message printed :-(


>  		return NULL;
>  	}
>  	if (n == NULL) {
> @@ -997,8 +995,8 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
>  			    node->internal_strong_refs == 0 &&
>  			    !(node == binder_context_mgr_node &&
>  			    node->has_strong_ref)) {
> -				printk(KERN_ERR "binder: invalid inc strong "
> -					"node for %d\n", node->debug_id);
> +				printk(KERN_ERR "binder:invalid inc strong node for %d\n",
> +					node->debug_id);

This used to print "binder: invalid inc..."
but now it prints  "binder:invalid inc..."


>  				return -EINVAL;
>  			}
>  			node->internal_strong_refs++;
> @@ -1013,8 +1011,8 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
>  			node->local_weak_refs++;
>  		if (!node->has_weak_ref && list_empty(&node->work.entry)) {
>  			if (target_list == NULL) {
> -				printk(KERN_ERR "binder: invalid inc weak node "
> -					"for %d\n", node->debug_id);
> +				printk(KERN_ERR "binder: invalid inc weak node for %d\n",
> +					node->debug_id);
>  				return -EINVAL;
>  			}
>  			list_add_tail(&node->work.entry, target_list);
> @@ -1206,10 +1204,11 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
>  {
>  	if (strong) {
>  		if (ref->strong == 0) {
> -			binder_user_error("binder: %d invalid dec strong, "
> -					  "ref %d desc %d s %d w %d\n",
> -					  ref->proc->pid, ref->debug_id,
> -					  ref->desc, ref->strong, ref->weak);
> +			binder_user_error("binder:%d invalid dec strong,ref %d desc %d s %d w %d\n",

Before your patch the line printed had a space between the comma after 
"strong" and before "ref" as in "strong, ref".
After your patch that space is gone :-(


> +						ref->proc->pid, ref->debug_id,
> +						ref->desc,
> +						ref->strong,
> +						ref->weak);

Why are you keeping "ref->proc->pid, ref->debug_id," on one line but the 
rest on individual lines?

Why not this:
						ref->proc->pid, ref->debug_id,
						ref->desc, ref->strong,
						ref->weak);

all 3 lines stay below the 80 char limit and it looks nicer.


>  			return -EINVAL;
>  		}
>  		ref->strong--;
> @@ -1221,10 +1220,12 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
>  		}
>  	} else {
>  		if (ref->weak == 0) {
> -			binder_user_error("binder: %d invalid dec weak, "
> -					  "ref %d desc %d s %d w %d\n",
> -					  ref->proc->pid, ref->debug_id,
> -					  ref->desc, ref->strong, ref->weak);
> +			binder_user_error("binder: %d invalid dec weak,ref %d desc %d s %d w %d\n",
> +						ref->proc->pid,
> +						ref->debug_id,
> +						ref->desc,
> +						ref->strong,
> +						ref->weak);

Same comments here as above.


>  			return -EINVAL;
>  		}
>  		ref->weak--;
> @@ -3303,7 +3304,7 @@ static void print_binder_proc(struct seq_file *m,
>  		m->count = start_pos;
>  }
>  
> -static const char *binder_return_strings[] = {
> +static const char *const binder_return_strings[] = {

If you read the checkpatch warning this addresses you'll see that it says 
"static const char * array should probably be static const char * const"
But you changed it to "static const char *const".

A quick check for usage of the two forms:

[jj@arch linux]$ git grep -E "static +const +char *\* +const" | wc -l
673
[jj@arch linux]$ git grep -E "static +const +char *\*const" | wc -l
151

Suggests that the vast majority prefer the style that has a space before 
the final "const" and since a uniform style is preferable I'd say you 
should probably go with that instead.

>  	"BR_ERROR",
>  	"BR_OK",
>  	"BR_TRANSACTION",
> @@ -3324,7 +3325,7 @@ static const char *binder_return_strings[] = {
>  	"BR_FAILED_REPLY"
>  };
>  
> -static const char *binder_command_strings[] = {
> +static const char *const binder_command_strings[] = {
>  	"BC_TRANSACTION",
>  	"BC_REPLY",
>  	"BC_ACQUIRE_RESULT",
> @@ -3344,7 +3345,7 @@ static const char *binder_command_strings[] = {
>  	"BC_DEAD_BINDER_DONE"
>  };
>  
> -static const char *binder_objstat_strings[] = {
> +static const char *const binder_objstat_strings[] = {
>  	"proc",
>  	"thread",
>  	"node",

Same comment as above.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

